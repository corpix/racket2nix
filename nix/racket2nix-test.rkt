#lang racket
(require nix/racket2nix)
(require rackunit)

(provide (all-defined-out))

(define suite (begin
  (test-suite "racket2nix"
    (test-equal? "github-url->git-url turns github://.*/branch into https://.*#branch"
                 (github-url->git-url "github://github.com/mordae/racket-systemd/master")
                 "https://github.com/mordae/racket-systemd.git#master")
    (test-not-false "github-url? detects github:// URL"
                 (github-url? "github://github.com/mordae/racket-systemd/master"))
    (test-equal? "url-fallback-rev->url-rev-path tolerates github:// with trailing slash"
                 (match-let-values
                   ([(url _ _)
                     (url-fallback-rev->url-rev-path
                       "github://github.com/stchang/parsack/master/"
                       "b45f0f5ed5f8dd3f1ccebaaec3204b27032843c6")])
                   url)
                 "https://github.com/stchang/parsack.git")
    (test-equal? "github-url->git-url puts the .git in the right place when path query and no trailing slash"
                 (github-url->git-url "https://github.com/rmculpepper/binaryio?path=binaryio")
                 "https://github.com/rmculpepper/binaryio.git?path=binaryio"))))

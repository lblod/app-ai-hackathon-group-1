(in-package :mu-cl-resources)

(defparameter *include-count-in-paginated-responses* t)
(defparameter sparql:*experimental-no-application-graph-for-sudo-select-queries* t)
(defparameter *default-page-size* 20)

; Caching
(defparameter *cache-model-properties* t)
(defparameter *cache-count-queries* t)
(defparameter *supply-cache-headers-p* t)

(read-domain-file "domain.json")

;; -------------------------------------------------------------------------------------


(define-resource file ()
  :class (s-prefix "nfo:FileDataObject")
  :properties `((:name :string ,(s-prefix "nfo:fileName"))
                (:format :string ,(s-prefix "dct:format"))
                (:size :number ,(s-prefix "nfo:fileSize"))
                (:extension :string ,(s-prefix "dbpedia:fileExtension"))
                (:created :datetime ,(s-prefix "dct:created"))
                (:modified :datetime ,(s-prefix "dct:modified"))
                (:status :url ,(s-prefix "adms:status")))
  :has-one `((file :via ,(s-prefix "nie:dataSource")
                   :inverse t
                   :as "download"))
  :resource-base (s-url "http://data.lblod.info/files/")
  :features `(include-uri)
  :on-path "files")
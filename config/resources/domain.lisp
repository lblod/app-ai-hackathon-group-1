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

(define-resource activity ()
  :class (s-prefix "prov:Activity")
  :properties `((:type :url ,(s-prefix "rdf:type")))
  :has-many `((annotation :via ,(s-prefix "slimmeraadpleegomgeving:Activiteit.genereertAnnotatie")
                          :as "annotations"))
  :resource-base (s-url "http://data.lblod.info/activities/")
  :features `(include-uri)
  :on-path "activities")

(define-resource annotation ()
  :class (s-prefix "oa:Annotation")
  :properties `((:body :string ,(s-prefix "oa:hasBody"))
                (:resource :uri-set ,(s-prefix "oa:hasTarget")))
  :has-one `((validation :via ,(s-prefix "ext:hasValidation")
                         :as "validation")
             (activity :via ,(s-prefix "slimmeraadpleegomgeving:Activiteit.genereertAnnotatie")
                       :inverse t
                       :as "activity"))
  ;; If we had more time, the hasTarget relationship should link to a Resource via a hasMany relationship
  ;; For the sake of simplicity during the hackaton, we take a shotcut and just set it as a property
  ;; :has-many `((resource :via ,(s-prefix "oa:hasTarget")
  ;;                  :inverse t
  ;;                  :as "wasTargettedBy"))
  :resource-base (s-url "http://data.lblod.info/annotations/")
  :features `(include-uri)
  :on-path "annotations")

;; Made for AI validation "Validating that the AI system from the design and development stage works according
;; to requirements and meets objectives."
;; Not perfect, as it's supposed to be part of a lifecycle, but good enough for the hackaton
(define-resource validation ()
  :class (s-prefix "vair:Validation")
  :properties `((:creator :url ,(s-prefix "dct:creator"));; can be an Agent with more dev time :)
                (:created :datetime ,(s-prefix "dct:created"))
                (:accepted :datetime ,(s-prefix "dct:dateAccepted"))
                (:denied :datetime ,(s-prefix "ext:dateDenied")))
  :has-one `((annotation :via, (s-prefix "ext:hasValidation")
                         :inverse t
                         :as "annotation"))
  :resource-base (s-url "http://data.lblod.info/validations/")
  :features `(include-uri)
  :on-path "validations")

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
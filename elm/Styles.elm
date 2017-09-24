module Styles exposing (..)

import Html.Attributes
import Css exposing (..)
import Css.Elements exposing (body, li)
import Css.Namespace exposing (namespace)

styles =
    Css.asPairs >> Html.Attributes.style

flexColumn =
  [ displayFlex
  , flexDirection column
  ]

greyBorder =
  [ border3 (px 1) solid (rgb 11 14 17)
  ]

padMedium =
  [ padding (px 10)
  ]

marginMedium =
  [ margin (px 10)
  ]

bgBlue =
  [ backgroundColor (rgb 200 200 240)
  ]

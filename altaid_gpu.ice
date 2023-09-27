{
  "version": "1.2",
  "package": {
    "name": "",
    "version": "",
    "description": "",
    "author": "",
    "image": ""
  },
  "design": {
    "board": "iCE40-HX8K-EVB",
    "graph": {
      "blocks": [
        {
          "id": "371ef2c2-9a06-4746-b8d8-d4db38facbc8",
          "type": "basic.output",
          "data": {
            "name": "p0",
            "virtual": false,
            "pins": [
              {
                "index": "0",
                "name": "PIO3_00",
                "value": "E4"
              }
            ]
          },
          "position": {
            "x": 1760,
            "y": 216
          }
        },
        {
          "id": "05e7507e-2264-4428-b4f8-48139279c887",
          "type": "basic.output",
          "data": {
            "name": "p1",
            "virtual": false,
            "pins": [
              {
                "index": "0",
                "name": "PIO3_01",
                "value": "B2"
              }
            ]
          },
          "position": {
            "x": 1760,
            "y": 456
          }
        },
        {
          "id": "34289635-644b-4ee1-a90b-bc727d98990c",
          "type": "basic.output",
          "data": {
            "name": "p2",
            "virtual": false,
            "pins": [
              {
                "index": "0",
                "name": "PIO3_02",
                "value": "F5"
              }
            ]
          },
          "position": {
            "x": 1760,
            "y": 688
          }
        },
        {
          "id": "0a4d3101-3216-4411-b538-8fe12ee05abe",
          "type": "basic.constant",
          "data": {
            "name": "CLOCK_SCALE",
            "value": "50",
            "local": false
          },
          "position": {
            "x": -144,
            "y": 120
          }
        },
        {
          "id": "f46549df-e564-4953-933a-6e048095697c",
          "type": "basic.constant",
          "data": {
            "name": "LINE_PERIOD",
            "value": "64",
            "local": false
          },
          "position": {
            "x": 248,
            "y": 112
          }
        },
        {
          "id": "baa21090-58fe-4a26-855f-a56b6bd055ae",
          "type": "basic.constant",
          "data": {
            "name": "VSYNC_LENGTH",
            "value": "4",
            "local": false
          },
          "position": {
            "x": 976,
            "y": -40
          }
        },
        {
          "id": "ac19d625-fbbb-4ec6-9cbe-72454ea7d32d",
          "type": "basic.constant",
          "data": {
            "name": "MAX_LINE",
            "value": "312",
            "local": false
          },
          "position": {
            "x": 1152,
            "y": -40
          }
        },
        {
          "id": "6c013764-3d15-4fb8-8fdf-7250d3a16fec",
          "type": "basic.constant",
          "data": {
            "name": "IMAGE_START",
            "value": "5",
            "local": false
          },
          "position": {
            "x": 1320,
            "y": -40
          }
        },
        {
          "id": "6b46c551-423a-47de-9380-da95539eae5d",
          "type": "basic.constant",
          "data": {
            "name": "IMAGE_END",
            "value": "310",
            "local": false
          },
          "position": {
            "x": 1496,
            "y": -40
          }
        },
        {
          "id": "e8cf7d82-44c2-4449-9a4e-fb224accf56f",
          "type": "basic.info",
          "data": {
            "info": "",
            "readonly": true
          },
          "position": {
            "x": 1648,
            "y": -440
          },
          "size": {
            "width": 192,
            "height": 128
          }
        },
        {
          "id": "221afca0-270a-423c-8e00-2ae1d5e3c886",
          "type": "basic.info",
          "data": {
            "info": "100Mhz clock\n",
            "readonly": true
          },
          "position": {
            "x": -440,
            "y": 592
          },
          "size": {
            "width": 136,
            "height": 48
          }
        },
        {
          "id": "ada4285e-b957-4870-b7d3-7ca397617fbd",
          "type": "basic.code",
          "data": {
            "ports": {
              "in": [
                {
                  "name": "clk"
                }
              ],
              "out": [
                {
                  "name": "hsync"
                }
              ]
            },
            "params": [
              {
                "name": "SCALE"
              },
              {
                "name": "LINE_PERIOD"
              }
            ],
            "code": "reg [7:0] count = 1;\nreg us_clk = 1'b0;\n\nreg [5:0] time_on_line = 0;\nreg hsync = 1'b0;\n\n// 100Mhz to 1Mhz or 1us\nalways @(posedge clk)\n    begin\n        count <= count + 1;\n        if (count == SCALE)\n            begin\n                us_clk <= ~us_clk;\n                count <= 1;\n            end\n    end\n\n// keep track of us on current line\nalways @(posedge us_clk)\n    begin\n        time_on_line <= time_on_line + 1;\n        if (time_on_line == LINE_PERIOD - 1)\n            begin\n                time_on_line<= 0;\n            end\n    end\n    \n// generate pulse\nalways @(posedge us_clk)\n    begin\n        hsync <= time_on_line == 0; \n    end"
          },
          "position": {
            "x": -288,
            "y": 288
          },
          "size": {
            "width": 776,
            "height": 640
          }
        },
        {
          "id": "caf12028-8f24-4aec-bf77-4fa2abfb81bc",
          "type": "basic.code",
          "data": {
            "ports": {
              "in": [
                {
                  "name": "hsync"
                }
              ],
              "out": [
                {
                  "name": "gen_vsync"
                },
                {
                  "name": "draw_blank"
                },
                {
                  "name": "draw_image"
                },
                {
                  "name": "hsync_out"
                }
              ]
            },
            "params": [
              {
                "name": "VSYNC_LENGTH"
              },
              {
                "name": "MAX_LINE"
              },
              {
                "name": "START_IMAGE"
              },
              {
                "name": "END_IMAGE"
              }
            ],
            "code": "reg [8:0] line_count = 0;\nreg gen_vsync = 0;\nreg draw_blank = 0;\nreg draw_image = 0;\n\nparameter vsync_state = 2'b00;\nparameter blank_state = 2'b01;\nparameter image_state = 2'b10;\n\nreg [1:0] state = vsync_state;\n\nassign hsync_out = hsync;\n\n// keep track of current line\nalways @(posedge hsync)\n    begin\n        // this count is duplicated \n        line_count <= line_count + 1;\n        if (line_count == MAX_LINE)\n            line_count <= 0;\n    end\n    \n// state machine\nalways @(posedge hsync)\n    begin\n        if (line_count >= 0 && line_count < VSYNC_LENGTH)\n            state <= vsync_state;\n        else if (line_count > START_IMAGE && line_count < END_IMAGE)\n            state <= image_state;\n        else\n            state <= blank_state;\n    end\n    \nalways @(posedge hsync)\n    begin\n        if (state == vsync_state)\n            begin\n                gen_vsync <= 1;\n                draw_blank <= 0;\n                draw_image <= 0;\n            end\n        else if (state == blank_state)\n            begin\n                gen_vsync <= 0;\n                draw_blank <= 1;\n                draw_image <= 0;\n            end\n        else\n            begin\n                gen_vsync <= 0;\n                draw_blank <= 0;\n                draw_image <= 1;\n            end\n    end"
          },
          "position": {
            "x": 936,
            "y": 128
          },
          "size": {
            "width": 696,
            "height": 952
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "0a4d3101-3216-4411-b538-8fe12ee05abe",
            "port": "constant-out"
          },
          "target": {
            "block": "ada4285e-b957-4870-b7d3-7ca397617fbd",
            "port": "SCALE"
          }
        },
        {
          "source": {
            "block": "f46549df-e564-4953-933a-6e048095697c",
            "port": "constant-out"
          },
          "target": {
            "block": "ada4285e-b957-4870-b7d3-7ca397617fbd",
            "port": "LINE_PERIOD"
          }
        },
        {
          "source": {
            "block": "6c013764-3d15-4fb8-8fdf-7250d3a16fec",
            "port": "constant-out"
          },
          "target": {
            "block": "caf12028-8f24-4aec-bf77-4fa2abfb81bc",
            "port": "START_IMAGE"
          }
        },
        {
          "source": {
            "block": "6b46c551-423a-47de-9380-da95539eae5d",
            "port": "constant-out"
          },
          "target": {
            "block": "caf12028-8f24-4aec-bf77-4fa2abfb81bc",
            "port": "END_IMAGE"
          }
        },
        {
          "source": {
            "block": "baa21090-58fe-4a26-855f-a56b6bd055ae",
            "port": "constant-out"
          },
          "target": {
            "block": "caf12028-8f24-4aec-bf77-4fa2abfb81bc",
            "port": "VSYNC_LENGTH"
          }
        },
        {
          "source": {
            "block": "ac19d625-fbbb-4ec6-9cbe-72454ea7d32d",
            "port": "constant-out"
          },
          "target": {
            "block": "caf12028-8f24-4aec-bf77-4fa2abfb81bc",
            "port": "MAX_LINE"
          }
        },
        {
          "source": {
            "block": "ada4285e-b957-4870-b7d3-7ca397617fbd",
            "port": "hsync"
          },
          "target": {
            "block": "caf12028-8f24-4aec-bf77-4fa2abfb81bc",
            "port": "hsync"
          }
        },
        {
          "source": {
            "block": "caf12028-8f24-4aec-bf77-4fa2abfb81bc",
            "port": "gen_vsync"
          },
          "target": {
            "block": "371ef2c2-9a06-4746-b8d8-d4db38facbc8",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "caf12028-8f24-4aec-bf77-4fa2abfb81bc",
            "port": "draw_blank"
          },
          "target": {
            "block": "05e7507e-2264-4428-b4f8-48139279c887",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "caf12028-8f24-4aec-bf77-4fa2abfb81bc",
            "port": "draw_image"
          },
          "target": {
            "block": "34289635-644b-4ee1-a90b-bc727d98990c",
            "port": "in"
          }
        }
      ]
    }
  },
  "dependencies": {}
}
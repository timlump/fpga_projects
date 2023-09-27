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
          "id": "0a4d3101-3216-4411-b538-8fe12ee05abe",
          "type": "basic.constant",
          "data": {
            "name": "CLOCK_SCALE",
            "value": "50",
            "local": false
          },
          "position": {
            "x": -208,
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
            "x": 48,
            "y": 112
          }
        },
        {
          "id": "d0df1bc7-306e-4a4c-a636-7299a1415d30",
          "type": "basic.constant",
          "data": {
            "name": "MAX_LINE",
            "value": "312",
            "local": false
          },
          "position": {
            "x": 304,
            "y": 112
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
            "y": 640
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
                },
                {
                  "name": "vsync"
                },
                {
                  "name": "time_on_line",
                  "range": "[5:0]",
                  "size": 6
                },
                {
                  "name": "line_count",
                  "range": "[8:0]",
                  "size": 9
                }
              ]
            },
            "params": [
              {
                "name": "SCALE"
              },
              {
                "name": "LINE_PERIOD"
              },
              {
                "name": "MAX_LINE"
              }
            ],
            "code": "reg [7:0] count = 1;\nreg [8:0] line_count = 0;\nreg us_clk = 1'b0;\n\nreg [5:0] time_on_line = 0;\nreg hsync = 1'b0;\nreg vsync = 1'b0;\n\n// 100Mhz to 1Mhz or 1us\nalways @(posedge clk)\n    begin\n        count <= count + 1;\n        if (count == SCALE)\n            begin\n                us_clk <= ~us_clk;\n                count <= 1;\n            end\n    end\n\n// keep track of position (time) on current line\nalways @(posedge us_clk)\n    begin\n        time_on_line <= time_on_line + 1;\n        if (time_on_line == LINE_PERIOD - 1)\n            begin\n                time_on_line<= 0;\n            end\n    end\n    \n// keep track of current line\nalways @(posedge us_clk)\n    begin\n        line_count <= line_count + 1;\n        if (line_count == MAX_LINE - 1)\n            line_count <= 0;\n    end\n    \n// generate pulse\nalways @(posedge us_clk)\n    begin\n        hsync <= time_on_line == 0;\n        vsync <= time_on_line == 0 && line_count == 0;\n    end"
          },
          "position": {
            "x": -288,
            "y": 288
          },
          "size": {
            "width": 768,
            "height": 728
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
            "block": "d0df1bc7-306e-4a4c-a636-7299a1415d30",
            "port": "constant-out"
          },
          "target": {
            "block": "ada4285e-b957-4870-b7d3-7ca397617fbd",
            "port": "MAX_LINE"
          }
        }
      ]
    }
  },
  "dependencies": {}
}
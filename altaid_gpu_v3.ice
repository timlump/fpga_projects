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
          "id": "0a1c60fc-1ea6-4d3f-a294-e3dc0479f657",
          "type": "basic.output",
          "data": {
            "name": "out",
            "virtual": false,
            "pins": [
              {
                "index": "0",
                "name": "PIO3_13",
                "value": "E2"
              }
            ]
          },
          "position": {
            "x": 712,
            "y": 312
          }
        },
        {
          "id": "a420bb08-fab2-4f12-a5dc-01661eda7ab3",
          "type": "basic.constant",
          "data": {
            "name": "target",
            "value": "2",
            "local": false
          },
          "position": {
            "x": 384,
            "y": 64
          }
        },
        {
          "id": "4652664d-8790-4840-aa2c-c6b904ce2265",
          "type": "basic.info",
          "data": {
            "info": "Clock Divider",
            "readonly": true
          },
          "position": {
            "x": 488,
            "y": 176
          },
          "size": {
            "width": 152,
            "height": 48
          }
        },
        {
          "id": "6e39b02a-0421-4de9-a4e6-0ea5f2e54467",
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
                  "name": "new_clk"
                }
              ]
            },
            "params": [
              {
                "name": "target"
              }
            ],
            "code": "reg new_clk = 1'b0;\nreg[7:0] tick_count = 0;\n\nparameter COUNT = (100 / target) / 2;\n\nalways @(posedge clk)\n    begin\n        tick_count <= tick_count + 1;\n        if (tick_count == COUNT - 1)\n            begin\n                new_clk <= ~new_clk;\n                tick_count <= 0;\n            end\n    end"
          },
          "position": {
            "x": 232,
            "y": 208
          },
          "size": {
            "width": 392,
            "height": 264
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "6e39b02a-0421-4de9-a4e6-0ea5f2e54467",
            "port": "new_clk"
          },
          "target": {
            "block": "0a1c60fc-1ea6-4d3f-a294-e3dc0479f657",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "a420bb08-fab2-4f12-a5dc-01661eda7ab3",
            "port": "constant-out"
          },
          "target": {
            "block": "6e39b02a-0421-4de9-a4e6-0ea5f2e54467",
            "port": "target"
          }
        }
      ]
    }
  },
  "dependencies": {}
}
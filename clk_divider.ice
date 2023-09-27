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
            "x": 1312,
            "y": 192
          }
        },
        {
          "id": "0f24ef83-fbc2-4e8d-8194-62f060240d8b",
          "type": "basic.output",
          "data": {
            "name": "DAC",
            "virtual": false,
            "range": "[0:7]",
            "pins": [
              {
                "index": "7",
                "name": "PIO3_00",
                "value": "E4"
              },
              {
                "index": "6",
                "name": "PIO3_01",
                "value": "B2"
              },
              {
                "index": "5",
                "name": "PIO3_02",
                "value": "F5"
              },
              {
                "index": "4",
                "name": "PIO3_03",
                "value": "B1"
              },
              {
                "index": "3",
                "name": "PIO3_04",
                "value": "C1"
              },
              {
                "index": "2",
                "name": "PIO3_05",
                "value": "C2"
              },
              {
                "index": "1",
                "name": "PIO3_06",
                "value": "F4"
              },
              {
                "index": "0",
                "name": "PIO3_07",
                "value": "D2"
              }
            ]
          },
          "position": {
            "x": 1312,
            "y": 272
          }
        },
        {
          "id": "a420bb08-fab2-4f12-a5dc-01661eda7ab3",
          "type": "basic.constant",
          "data": {
            "name": "target_hz",
            "value": "25",
            "local": false
          },
          "position": {
            "x": 400,
            "y": 56
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
            "x": 472,
            "y": 168
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
            "code": "reg new_clk = 1'b0;\n// must have the required precision to hold\n// COUNT\nreg[31:0] tick_count = 0;\n\nparameter COUNT = (100000000 / target) / 2;\n\nalways @(posedge clk)\n    begin\n        tick_count <= tick_count + 1;\n        if (tick_count == COUNT - 1)\n            begin\n                new_clk <= ~new_clk;\n                tick_count <= 0;\n            end\n    end"
          },
          "position": {
            "x": 232,
            "y": 208
          },
          "size": {
            "width": 432,
            "height": 328
          }
        },
        {
          "id": "917ef0cd-1637-4cc7-9e52-45a060560bd1",
          "type": "basic.code",
          "data": {
            "ports": {
              "in": [
                {
                  "name": "in_clk"
                }
              ],
              "out": [
                {
                  "name": "out_clk"
                },
                {
                  "name": "value",
                  "range": "[7:0]",
                  "size": 8
                }
              ]
            },
            "params": [],
            "code": "reg [7:0] value;\nwire out_clk = in_clk;\n\nalways @(posedge in_clk)\n  value <= value + 1;"
          },
          "position": {
            "x": 800,
            "y": 232
          },
          "size": {
            "width": 392,
            "height": 408
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "a420bb08-fab2-4f12-a5dc-01661eda7ab3",
            "port": "constant-out"
          },
          "target": {
            "block": "6e39b02a-0421-4de9-a4e6-0ea5f2e54467",
            "port": "target"
          }
        },
        {
          "source": {
            "block": "6e39b02a-0421-4de9-a4e6-0ea5f2e54467",
            "port": "new_clk"
          },
          "target": {
            "block": "917ef0cd-1637-4cc7-9e52-45a060560bd1",
            "port": "in_clk"
          }
        },
        {
          "source": {
            "block": "917ef0cd-1637-4cc7-9e52-45a060560bd1",
            "port": "value"
          },
          "target": {
            "block": "0f24ef83-fbc2-4e8d-8194-62f060240d8b",
            "port": "in"
          },
          "size": 8
        },
        {
          "source": {
            "block": "917ef0cd-1637-4cc7-9e52-45a060560bd1",
            "port": "out_clk"
          },
          "target": {
            "block": "0a1c60fc-1ea6-4d3f-a294-e3dc0479f657",
            "port": "in"
          }
        }
      ]
    }
  },
  "dependencies": {}
}
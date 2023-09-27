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
          "id": "67afdf0d-905b-464d-acf7-b43fe6c680e6",
          "type": "basic.output",
          "data": {
            "name": "out_clk",
            "virtual": true,
            "pins": [
              {
                "index": "0",
                "name": "NULL",
                "value": "NULL"
              }
            ]
          },
          "position": {
            "x": 792,
            "y": 432
          }
        },
        {
          "id": "edfd620d-fb24-4591-9efa-5b043e8b3b17",
          "type": "basic.input",
          "data": {
            "name": "clk",
            "virtual": true,
            "pins": [
              {
                "index": "0",
                "name": "NULL",
                "value": "NULL"
              }
            ],
            "clock": true
          },
          "position": {
            "x": 16,
            "y": 432
          }
        },
        {
          "id": "f6edc2ce-f36d-44bc-afda-3233251912f8",
          "type": "basic.constant",
          "data": {
            "name": "target",
            "value": "25",
            "local": false
          },
          "position": {
            "x": 392,
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
            "x": 400,
            "y": 160
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
            "code": "reg new_clk = 1'b0;\n// must have the required precision to hold\n// COUNT\nreg[31:0] tick_count = 0;\n\nparameter COUNT = (100000000 / target) / 2;\n\nalways @(posedge clk)\n    begin\n        tick_count <= tick_count + 1;\n        \n        if (tick_count == COUNT - 1)\n            begin\n                new_clk <= ~new_clk;\n                tick_count <= 0;\n            end\n    end"
          },
          "position": {
            "x": 160,
            "y": 208
          },
          "size": {
            "width": 560,
            "height": 512
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "edfd620d-fb24-4591-9efa-5b043e8b3b17",
            "port": "out"
          },
          "target": {
            "block": "6e39b02a-0421-4de9-a4e6-0ea5f2e54467",
            "port": "clk"
          }
        },
        {
          "source": {
            "block": "f6edc2ce-f36d-44bc-afda-3233251912f8",
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
            "block": "67afdf0d-905b-464d-acf7-b43fe6c680e6",
            "port": "in"
          }
        }
      ]
    }
  },
  "dependencies": {}
}
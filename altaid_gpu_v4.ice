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
          "id": "239dc3cc-4016-4b99-b8ff-d5bfef5b472a",
          "type": "basic.output",
          "data": {
            "name": "DAC",
            "virtual": false,
            "range": "[7:0]",
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
            "x": 1264,
            "y": 200
          }
        },
        {
          "id": "0d4917cd-be27-4fb1-891d-6e45f5d602d8",
          "type": "basic.output",
          "data": {
            "name": "dac_clk",
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
            "x": 1280,
            "y": 848
          }
        },
        {
          "id": "ca790223-4e99-4c29-8a6a-fe062c1c85ec",
          "type": "basic.constant",
          "data": {
            "name": "pixel_scale",
            "value": "4",
            "local": false
          },
          "position": {
            "x": -88,
            "y": 336
          }
        },
        {
          "id": "98be30b5-6df2-4e5a-9a2e-905ba62e3278",
          "type": "basic.constant",
          "data": {
            "name": "line_hz",
            "value": "15625",
            "local": false
          },
          "position": {
            "x": -80,
            "y": 96
          }
        },
        {
          "id": "898fca37-53a0-460f-a0f1-79744a9381fa",
          "type": "6a50747141af6d1cfb3bb9d0093fb94862ff5a65",
          "position": {
            "x": -88,
            "y": 432
          },
          "size": {
            "width": 96,
            "height": 64
          }
        },
        {
          "id": "3c83ac28-deab-41a6-9a68-661023ea14cb",
          "type": "d07e3319511607b0a85b5cd5e5ea668b193ea2c9",
          "position": {
            "x": -80,
            "y": 216
          },
          "size": {
            "width": 96,
            "height": 64
          }
        },
        {
          "id": "ade1b508-029d-4b6e-9482-bf3d1fe4e374",
          "type": "basic.info",
          "data": {
            "info": "100Mhz going through\nPrescaler4 goes to 6.25Mhz\nwhich is sufficient for a 320\npixel horizontal res",
            "readonly": true
          },
          "position": {
            "x": -288,
            "y": 320
          },
          "size": {
            "width": 192,
            "height": 128
          }
        },
        {
          "id": "236bbaea-095c-4044-8f25-18f73bc9d3ca",
          "type": "basic.code",
          "data": {
            "ports": {
              "in": [
                {
                  "name": "line_clk"
                },
                {
                  "name": "pixel_clk"
                }
              ],
              "out": [
                {
                  "name": "video_output",
                  "range": "[7:0]",
                  "size": 8
                },
                {
                  "name": "dac_clk"
                }
              ]
            },
            "params": [],
            "code": "reg[8:0] y_pos = 0; // 0 to 311 (using single frame 312 PAL)\nreg[8:0] x_pos = 0; // 0 to 399 (6.25Mhz clock - 400 pixels)\n\nparameter MAX_Y = 311;\nparameter MAX_X = 399;\n\n// increment line count\nalways @(posedge line_clk)\n    begin\n        y_pos <= y_pos + 1;\n        if (y_pos > MAX_Y)\n            begin\n                y_pos <= 0;\n            end\n    end\n\nwire dac_clk;\nassign dac_clk = pixel_clk;\n\n// increment pixel count\nalways @(posedge pixel_clk)\n    begin\n        x_pos <= x_pos + 1;\n        if (x_pos > MAX_X)\n            begin\n                x_pos <= 0;\n            end\n    end\n    \n// video timings and states\nparameter VBLANK_STATE = 0;\nparameter HBLANK_STATE = 1;\nparameter IMAGE_STATE = 2;\nreg[1:0] state = VBLANK_STATE;\n\nparameter VBLANK_LINE_COUNT = 4;\nparameter HBLANK_PIXEL_COUNT = 80; // leaves 320 for image\n\nparameter BLACK = 8'h55;\nparameter WHITE = 8'hFF;\nparameter SYNC = 8'h00;\n\nreg[7:0] video_output = BLACK;\n\nalways @(posedge pixel_clk)\n    begin\n        if (y_pos < VBLANK_LINE_COUNT)\n            state <= VBLANK_STATE;\n        else \n            begin\n                if (x_pos < HBLANK_PIXEL_COUNT)\n                    state <= HBLANK_STATE;\n                else\n                    state <= IMAGE_STATE;\n            end\n            \n        \n        if (state == VBLANK_STATE)\n            begin\n                video_output <= SYNC;\n            end\n        else if (state == HBLANK_STATE)\n            begin\n                if (x_pos < 29)\n                    video_output <= SYNC;\n                else\n                    video_output <= BLACK;\n            end\n        else\n            begin\n                if (x_pos > 160 && x_pos < 300 && y_pos > 100 && y_pos < 200)\n                    video_output <= WHITE;\n                else\n                    video_output <= BLACK;\n            end\n    end"
          },
          "position": {
            "x": 328,
            "y": 72
          },
          "size": {
            "width": 808,
            "height": 1320
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "ca790223-4e99-4c29-8a6a-fe062c1c85ec",
            "port": "constant-out"
          },
          "target": {
            "block": "898fca37-53a0-460f-a0f1-79744a9381fa",
            "port": "de2d8a2d-7908-48a2-9e35-7763a45886e4"
          }
        },
        {
          "source": {
            "block": "98be30b5-6df2-4e5a-9a2e-905ba62e3278",
            "port": "constant-out"
          },
          "target": {
            "block": "3c83ac28-deab-41a6-9a68-661023ea14cb",
            "port": "f6edc2ce-f36d-44bc-afda-3233251912f8"
          }
        },
        {
          "source": {
            "block": "3c83ac28-deab-41a6-9a68-661023ea14cb",
            "port": "67afdf0d-905b-464d-acf7-b43fe6c680e6"
          },
          "target": {
            "block": "236bbaea-095c-4044-8f25-18f73bc9d3ca",
            "port": "line_clk"
          }
        },
        {
          "source": {
            "block": "898fca37-53a0-460f-a0f1-79744a9381fa",
            "port": "7e07d449-6475-4839-b43e-8aead8be2aac"
          },
          "target": {
            "block": "236bbaea-095c-4044-8f25-18f73bc9d3ca",
            "port": "pixel_clk"
          }
        },
        {
          "source": {
            "block": "236bbaea-095c-4044-8f25-18f73bc9d3ca",
            "port": "video_output"
          },
          "target": {
            "block": "239dc3cc-4016-4b99-b8ff-d5bfef5b472a",
            "port": "in"
          },
          "size": 8
        },
        {
          "source": {
            "block": "236bbaea-095c-4044-8f25-18f73bc9d3ca",
            "port": "dac_clk"
          },
          "target": {
            "block": "0d4917cd-be27-4fb1-891d-6e45f5d602d8",
            "port": "in"
          }
        }
      ]
    }
  },
  "dependencies": {
    "6a50747141af6d1cfb3bb9d0093fb94862ff5a65": {
      "package": {
        "name": "PrescalerN",
        "version": "0.1",
        "description": "Parametric N-bits prescaler",
        "author": "Juan Gonzalez (Obijuan)",
        "image": ""
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "e19c6f2f-5747-4ed1-87c8-748575f0cc10",
              "type": "basic.input",
              "data": {
                "name": "",
                "clock": true
              },
              "position": {
                "x": 0,
                "y": 256
              }
            },
            {
              "id": "7e07d449-6475-4839-b43e-8aead8be2aac",
              "type": "basic.output",
              "data": {
                "name": ""
              },
              "position": {
                "x": 720,
                "y": 256
              }
            },
            {
              "id": "de2d8a2d-7908-48a2-9e35-7763a45886e4",
              "type": "basic.constant",
              "data": {
                "name": "N",
                "value": "22",
                "local": false
              },
              "position": {
                "x": 352,
                "y": 56
              }
            },
            {
              "id": "2330955f-5ce6-4d1c-8ee4-0a09a0349389",
              "type": "basic.code",
              "data": {
                "code": "//-- Number of bits of the prescaler\n//parameter N = 22;\n\n//-- divisor register\nreg [N-1:0] divcounter;\n\n//-- N bit counter\nalways @(posedge clk_in)\n  divcounter <= divcounter + 1;\n\n//-- Use the most significant bit as output\nassign clk_out = divcounter[N-1];",
                "params": [
                  {
                    "name": "N"
                  }
                ],
                "ports": {
                  "in": [
                    {
                      "name": "clk_in"
                    }
                  ],
                  "out": [
                    {
                      "name": "clk_out"
                    }
                  ]
                }
              },
              "position": {
                "x": 176,
                "y": 176
              },
              "size": {
                "width": 448,
                "height": 224
              }
            }
          ],
          "wires": [
            {
              "source": {
                "block": "2330955f-5ce6-4d1c-8ee4-0a09a0349389",
                "port": "clk_out"
              },
              "target": {
                "block": "7e07d449-6475-4839-b43e-8aead8be2aac",
                "port": "in"
              }
            },
            {
              "source": {
                "block": "e19c6f2f-5747-4ed1-87c8-748575f0cc10",
                "port": "out"
              },
              "target": {
                "block": "2330955f-5ce6-4d1c-8ee4-0a09a0349389",
                "port": "clk_in"
              }
            },
            {
              "source": {
                "block": "de2d8a2d-7908-48a2-9e35-7763a45886e4",
                "port": "constant-out"
              },
              "target": {
                "block": "2330955f-5ce6-4d1c-8ee4-0a09a0349389",
                "port": "N"
              }
            }
          ]
        }
      }
    },
    "d07e3319511607b0a85b5cd5e5ea668b193ea2c9": {
      "package": {
        "name": "",
        "version": "",
        "description": "",
        "author": "",
        "image": ""
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "67afdf0d-905b-464d-acf7-b43fe6c680e6",
              "type": "basic.output",
              "data": {
                "name": "out_clk"
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
      }
    }
  }
}
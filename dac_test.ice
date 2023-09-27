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
          "id": "beaedfb0-bb00-4ab0-a7be-8028a667ca35",
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
            "x": 392,
            "y": 96
          }
        },
        {
          "id": "c96ceb9c-c52b-425f-abfd-e6be4e4398ed",
          "type": "basic.output",
          "data": {
            "name": "OUT_CLK",
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
            "x": 392,
            "y": 400
          }
        },
        {
          "id": "c83b156a-3161-44c9-b299-1016839c37a7",
          "type": "c7175799fcfb55ecbec4d6bd4a75841c0e62695b",
          "position": {
            "x": 200,
            "y": 400
          },
          "size": {
            "width": 96,
            "height": 64
          }
        },
        {
          "id": "fe3d470c-c548-485b-ab03-200bb8725012",
          "type": "c7175799fcfb55ecbec4d6bd4a75841c0e62695b",
          "position": {
            "x": -280,
            "y": 208
          },
          "size": {
            "width": 96,
            "height": 64
          }
        },
        {
          "id": "af922a08-8d9b-4989-9944-8122acb476b4",
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
                  "name": "value",
                  "range": "[7:0]",
                  "size": 8
                }
              ]
            },
            "params": [],
            "code": "reg [7:0] value;\n\nalways @(posedge clk)\n  value <= value + 1;\n"
          },
          "position": {
            "x": -120,
            "y": 176
          },
          "size": {
            "width": 304,
            "height": 128
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "c83b156a-3161-44c9-b299-1016839c37a7",
            "port": "7e07d449-6475-4839-b43e-8aead8be2aac"
          },
          "target": {
            "block": "c96ceb9c-c52b-425f-abfd-e6be4e4398ed",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "af922a08-8d9b-4989-9944-8122acb476b4",
            "port": "value"
          },
          "target": {
            "block": "beaedfb0-bb00-4ab0-a7be-8028a667ca35",
            "port": "in"
          },
          "size": 8
        },
        {
          "source": {
            "block": "fe3d470c-c548-485b-ab03-200bb8725012",
            "port": "7e07d449-6475-4839-b43e-8aead8be2aac"
          },
          "target": {
            "block": "af922a08-8d9b-4989-9944-8122acb476b4",
            "port": "clk"
          }
        }
      ]
    }
  },
  "dependencies": {
    "c7175799fcfb55ecbec4d6bd4a75841c0e62695b": {
      "package": {
        "name": "Prescaler22",
        "version": "0.1",
        "description": "22-bits prescaler",
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
                "x": 96,
                "y": 160
              }
            },
            {
              "id": "7e07d449-6475-4839-b43e-8aead8be2aac",
              "type": "basic.output",
              "data": {
                "name": ""
              },
              "position": {
                "x": 448,
                "y": 160
              }
            },
            {
              "id": "001a65af-f50d-4dbf-be8a-e0a3bb11df68",
              "type": "basic.constant",
              "data": {
                "name": "N",
                "value": "22",
                "local": true
              },
              "position": {
                "x": 288,
                "y": 48
              }
            },
            {
              "id": "98bd9928-772f-4216-99c6-325632479ab9",
              "type": "435b29b7b65c2c6d3c3df9bacef7e063156a0f7f",
              "position": {
                "x": 288,
                "y": 160
              },
              "size": {
                "width": 96,
                "height": 64
              }
            }
          ],
          "wires": [
            {
              "source": {
                "block": "e19c6f2f-5747-4ed1-87c8-748575f0cc10",
                "port": "out"
              },
              "target": {
                "block": "98bd9928-772f-4216-99c6-325632479ab9",
                "port": "e19c6f2f-5747-4ed1-87c8-748575f0cc10"
              }
            },
            {
              "source": {
                "block": "001a65af-f50d-4dbf-be8a-e0a3bb11df68",
                "port": "constant-out"
              },
              "target": {
                "block": "98bd9928-772f-4216-99c6-325632479ab9",
                "port": "de2d8a2d-7908-48a2-9e35-7763a45886e4"
              }
            },
            {
              "source": {
                "block": "98bd9928-772f-4216-99c6-325632479ab9",
                "port": "7e07d449-6475-4839-b43e-8aead8be2aac"
              },
              "target": {
                "block": "7e07d449-6475-4839-b43e-8aead8be2aac",
                "port": "in"
              }
            }
          ]
        }
      }
    },
    "435b29b7b65c2c6d3c3df9bacef7e063156a0f7f": {
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
            },
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
    }
  }
}
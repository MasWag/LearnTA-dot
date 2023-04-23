LearnTA-dot
===========

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](./LICENSE)

This repository provides a tool to convert the timed automata learned by [LearnTA](https://github.com/MasWag/LearnTA) to the DOT format for rendering with graphviz.

Requirements
------------

- [stack](https://docs.haskellstack.org/en/stable/)
- [Graphviz](https://graphviz.org/): strictly speaking, Graphviz is unnecessary but it is used for rendering.

Usage
-----

Given a DOT file of LearnTA, LearnTA-dot outputs a DOT file for Graphviz. For example, the following command renders examples/light.dot using graphviz.

```sh
stack run < ./examples/light.dot | dot -Tpng > ./light.png
```

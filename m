Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaKJHVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 02:21:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:59290 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbaKJHT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 02:19:56 -0500
X-AuditID: cbfee68f-f791c6d000004834-1b-546067144acd
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: cw00.choi@samsung.com, geunsik.lim@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, Beomho Seo <beomho.seo@samsung.com>
Subject: [PATCH v2 0/5] mfd: rt5033: Add Richtek RT5033 drivers
Date: Mon, 10 Nov 2014 16:19:42 +0900
Message-id: <1415603987-32475-1-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsWyRsSkUFc0PSHE4Px0JovTn7axW1z/8pzV
	Yv6Rc6wWfya0sllMuj+BxeLyrjlsFp97jzBazJj8ks2Bw6NvyypGj8+b5AKYorhsUlJzMstS
	i/TtErgy1vRPZCr4L1ixZHlEA2MTbxcjJ4eEgInEvPfv2CBsMYkL99aD2UICSxklNh7IhanZ
	u7qFqYuRCyi+iFHi+M5WFginjUni86XLTCBVbAKaEu+nXGEBsUUEIiTOLpsFVsQs0M4o8W5m
	CztIQljAXqJpzRrGLkYODhYBVYmFc/xAwrwCbhKzTp5nBglLCChIzJlkA9IqIfCZTWJV01tG
	kBoWAQGJb5MPsUDUyEpsOsAMcZykxMEVN1gmMAouYGRYxSiaWpBcUJyUXmSsV5yYW1yal66X
	nJ+7iREYnqf/PevfwXj3gPUhRgEORiUeXo8v8SFCrIllxZW5hxhNgTZMZJYSTc4HRkFeSbyh
	sZmRhamJqbGRuaWZkjjvQqmfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYt9y7/m5W6R+m
	lLo3AUbic+p37p7fbtT8NH5ZBmPHnjNWJ/dcfhqsE/dD0HFNfYDFdv/XR+ojGbK096081fh+
	/+kbaxxDVn2abNrFzP/oifqnmWWrb4a26TyoXWi1ulDOv/ixdqW0a92ap9E82btdwves3vb6
	/J3rfYf0WS7PMtP26rpo/kv7uRJLcUaioRZzUXEiAHnjBBxKAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e+xgK5IekKIwfkr5hanP21jt7j+5Tmr
	xfwj51gt/kxoZbOYdH8Ci8XlXXPYLD73HmG0mDH5JZsDh0ffllWMHp83yQUwRTUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZqzpn8hU8F+wYsnyiAbGJt4uRk4OCQETib2r
	W5ggbDGJC/fWs3UxcnEICSxilDi+s5UFwmljkvh86TJYFZuApsT7KVdYQGwRgQiJs8tmgRUx
	C7QzSryb2cIOkhAWsJdoWrOGsYuRg4NFQFVi4Rw/kDCvgJvErJPnmUHCEgIKEnMm2Uxg5F7A
	yLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzj8n0ntYFzZYHGIUYCDUYmH1+FtfIgQa2JZ
	cWXuIUYJDmYlEd7a/0Ah3pTEyqrUovz4otKc1OJDjKZAuycyS4km5wNjM68k3tDYxMzI0sjc
	0MLI2FxJnPdAq3WgkEB6YklqdmpqQWoRTB8TB6dUA2Pjs4nTF8f8Xa/rZTRrlqhyVffDvfEe
	+owPomf7nH9YYhqyfI3jhvRXpe8/XP8ww/Z1lRS75rWMGU+n7lzcGFvwTiujWaOea/7PpohH
	63PY5tn1LVuwOcL0cczPcG3PkDldsWu/vLFPl3mnlPv/N/Occ5fLLi2d7CHMwcI+z27Ojg1P
	Xq8VYI1TYinOSDTUYi4qTgQAL3dFapUCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patchset adds driver for Richtek rt5033 chip The chip contains
switching charge mode Li-Ion/Li-Polymer battery charger, fuelgauge, regulators.
This patchset provides common support for accessing the device.
This patchset have been tested base on exynos board.

Changes in v2:
- Remove volatile_reg callback. Because this driver not in use regmap cache.
- Remove unnecessary subnode of_compatible.
- Add definde for set high impedance mode of charger.
- Remove unnecessary device specific code.
- Fix wrong register name.
- Fix wrong error message.
- Fix return vallue at error case.
- Revise binding documentation.

Beomho Seo (5):
  mfd: rt5033: Add Richtek RT5033 driver core.
  regulator: rt5033: Add RT5033 Regulator device driver
  power: rt5033_battery: Add RT5033 Fuel gauge device driver
  power: rt5033_charger: Add RT5033 charger device driver
  Documentation: Add documentation for rt5033 multifunction device

 Documentation/devicetree/bindings/mfd/rt5033.txt   |  108 +++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/mfd/Kconfig                                |   11 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/rt5033.c                               |  156 +++++++
 drivers/power/Kconfig                              |   16 +
 drivers/power/Makefile                             |    2 +
 drivers/power/rt5033_battery.c                     |  177 +++++++
 drivers/power/rt5033_charger.c                     |  485 ++++++++++++++++++++
 drivers/regulator/Kconfig                          |    8 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/rt5033-regulator.c               |  123 +++++
 include/linux/mfd/rt5033-private.h                 |  260 +++++++++++
 include/linux/mfd/rt5033.h                         |   64 +++
 14 files changed, 1413 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt
 create mode 100644 drivers/mfd/rt5033.c
 create mode 100644 drivers/power/rt5033_battery.c
 create mode 100644 drivers/power/rt5033_charger.c
 create mode 100644 drivers/regulator/rt5033-regulator.c
 create mode 100644 include/linux/mfd/rt5033-private.h
 create mode 100644 include/linux/mfd/rt5033.h

-- 
1.7.9.5


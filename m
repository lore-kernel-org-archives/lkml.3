Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbbAVAi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 19:38:26 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:49290 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbbAVAiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 19:38:16 -0500
X-AuditID: cbfee68e-f79b46d000002b74-f1-54c04675403f
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, sre@kernel.org, robh+dt@kernel.org
Cc: lee.jone@linaro.org, broonie@kernel.org, dbaryshkov@gmail.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        Beomho Seo <beomho.seo@samsung.com>
Subject: [PATCH v3 0/2] power: rt5033: Add Richtek RT533 drivers
Date: Thu, 22 Jan 2015 09:38:10 +0900
Message-id: <1421887092-4070-1-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkRLfM7UCIQf9aRovTn7axW0x9+ITN
	4vqX56wWk568Z7aYf+Qcq0X/m4WsFuderWS0mHR/AovF+z1nGC0u75rDZvG59wijxdLrF5ks
	Jkxfy2LRuvcIu8Xp3SUWMya/ZHMQ8Fgzbw2jx+W+XiaPnbPusnusXP6FzWPTqk42jzvX9rB5
	9G1ZxejxeZNcAEcUl01Kak5mWWqRvl0CV8bZq7dZCz5xVBzu+s3cwPiErYuRk0NCwETizIdT
	zBC2mMSFe+uB4lwcQgJLGSXuvZ8DV3TnwFZmiMQiRom1T08wQjhtTBL721rA2tkENCXeT7nC
	AmKLCNRITDrzHmwUs8AEJom/nzezgySEBRwk2o79ARvLIqAq8X/FTSYQm1fAVWLS/VusXYwc
	QOsUJOZMsgHplRC4xS5xes9HqHoBiW+TD7FA1MhKbDoAdbakxMEVN1gmMAouYGRYxSiaWpBc
	UJyUXmSkV5yYW1yal66XnJ+7iREYL6f/PevbwXjzgPUhRgEORiUe3heK+0OEWBPLiitzDzGa
	Am2YyCwlmpwPjMq8knhDYzMjC1MTU2Mjc0szJXHeBKmfwUIC6YklqdmpqQWpRfFFpTmpxYcY
	mTg4pRoYlf4/V+41b3p1QiJ4a8zPlEuGLY7bNRssj1r1zYrKcBHRlWKObUmbzOhf+nLpd5HX
	Gg3O8jYle3Y9d/7peY4xV9yS4Vns0y0CT9vVkk+US7Pt2y5/dvYORsPXXmJf9xRuePP98OMr
	O6Yo/yi/H6nDum/Op4qbCr179v555metlrqx8OAE1yUJSizFGYmGWsxFxYkAwFulQpICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t9jAd1StwMhBq0NphanP21jt5j68Amb
	xfUvz1ktJj15z2wx/8g5Vov+NwtZLc69WsloMen+BBaL93vOMFpc3jWHzeJz7xFGi6XXLzJZ
	TJi+lsWide8RdovTu0ssZkx+yeYg4LFm3hpGj8t9vUweO2fdZfdYufwLm8emVZ1sHneu7WHz
	6NuyitHj8ya5AI6oBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFsl
	F58AXbfMHKAXlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZZ6/eZi34
	xFFxuOs3cwPjE7YuRk4OCQETiTsHtjJD2GISF+6tB4pzcQgJLGKUWPv0BCOE08Yksb+tBayK
	TUBT4v2UKywgtohAjcSkM+/BOpgFJjBJ/P28mR0kISzgINF27A/YChYBVYn/K24ygdi8Aq4S
	k+7fYu1i5ABapyAxZ5LNBEbuBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCo/GZ1A7G
	lQ0WhxgFOBiVeHhfKO4PEWJNLCuuzD3EKMHBrCTC66FxIESINyWxsiq1KD++qDQntfgQoynQ
	8onMUqLJ+cBEkVcSb2hsYmZkaWRuaGFkbK4kzqtk3xYiJJCeWJKanZpakFoE08fEwSnVwOi5
	z21qRFTd/Os335edZtp1e9KTXYv0Kp6n/ll4ePuxltNvcxkfnf+1Q8EpNrXfUK1L9X0v//UX
	RvOVBWd0Olqf/KnwZ+nZmN6czv5PuZsOrd1Wevae6n45xzbptL2rfqovO8bF8kvy6+KAdf4X
	BO+nvXHKPRnbsespX0vAZf8AW4m0XsHE/65KLMUZiYZazEXFiQDVn/3v3AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds driver for Richtek rt5033 chip The chip contains
switching charge mode Li-Ion/Li-Polymer battery charger, fuelgauge.
Additionally, This includes document for device tree of RT5033 device.

RT5033 core driver is applied by Lee Jones.
RT5033 regulator driver is applied by Mark Brown.
RT5033 fuelgauge driver is applied by Sebastian Reichel.

Changes in v3:
- Applied one of patchset.
- Add acked-by.

Changes in v2:
- Revise binding documentation..

Beomho Seo (2):
  power: rt5033_charger: Add RT5033 charger device driver
  Documentation: Add documentation for rt5033 multifunction device

 Documentation/devicetree/bindings/mfd/rt5033.txt   |  101 ++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/power/Kconfig                              |    8 +
 drivers/power/Makefile                             |    1 +
 drivers/power/rt5033_charger.c                     |  485 ++++++++++++++++++++
 5 files changed, 596 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt
 create mode 100644 drivers/power/rt5033_charger.c

-- 
1.7.9.5


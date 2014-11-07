Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaKGCwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 21:52:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:27654 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaKGCwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 21:52:12 -0500
X-AuditID: cbfee691-f79b86d000004a5a-dc-545c33d97a59
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, kyungmin.park@samsung.com, cw00.choi@samsung.com,
        jonghwa3.lee@samsung.com, geunsik.lim@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        Beomho Seo <beomho.seo@samsung.com>
Subject: [PATCH 0/5] mfd: rt5033: Add Richtek RT5033 drivers
Date: Fri, 07 Nov 2014 11:52:02 +0900
Message-id: <1415328727-16245-1-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWyRsSkUPemcUyIwe3zyhanP21jt5j68Amb
	xfUvz1ktJj15z2wx/8g5VouJKyczW/S/Wchq8WdCK5vFuVcrGS0m3Z/AYtF59gmzxdmmN+wW
	978eZbT4dqWDyeLyrjlsFp97jzBaLL1+kcliwvS1LBate4+wW5zuZrU4vbvEYsbkl2wOYh5r
	5q1h9Ljc18vksXPWXXaPlcu/sHlsXqHlsWlVJ5vHnWt72DzmnQz06NuyitHj8ya5AK4oLpuU
	1JzMstQifbsErox5H7+xFUzmr3i0ZxJLA+Mtri5GTg4JAROJxT8us0HYYhIX7q0Hsrk4hASW
	MkqsfLmUDaaoacoMZojEdEaJBY09rBBOG5PE67+/mUCq2AQ0Jd5PucICYosIREicXTaLBaSI
	WeAUs8T603/AEsICNhLvn31jBrFZBFQlOjZ+BLN5BdwkJr/rAFrHAbROQWLOJBuQXgmBXg6J
	7YtvsUDUC0h8m3yIBaJGVmLTAWaI6yQlDq64wTKBUXABI8MqRtHUguSC4qT0IlO94sTc4tK8
	dL3k/NxNjMDIO/3v2cQdjPcPWB9iFOBgVOLhvcEbEyLEmlhWXJl7iNEUaMNEZinR5HxgfOeV
	xBsamxlZmJqYGhuZW5opifPqSP8MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBYdnd9tNAF
	9R9x8TOUbr43k+TIKd51s7OvTUzIzv7izQkiuowf+uxuVzrNfrnp8dzchLVB/a3+t+UftDHl
	32XZ+eKGf/hbt19rVnCr//H08ri+K29T7Qzt9OcJLX/myzwvef/mg+jZTuPCiFnTOLUZJHWE
	vte+TPy4YruA14FpHZtnr/EOuPhciaU4I9FQi7moOBEAsCS4sbcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t9jQd2bxjEhBo/WS1qc/rSN3WLqwyds
	Fte/PGe1mPTkPbPF/CPnWC0mrpzMbNH/ZiGrxZ8JrWwW516tZLSYdH8Ci0Xn2SfMFmeb3rBb
	3P96lNHi25UOJovLu+awWXzuPcJosfT6RSaLCdPXsli07j3CbnG6m9Xi9O4SixmTX7I5iHms
	mbeG0eNyXy+Tx85Zd9k9Vi7/wuaxeYWWx6ZVnWwed67tYfOYdzLQo2/LKkaPz5vkAriiGhht
	MlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4D+VFIoS8wp
	BQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmzPv4ja1gMn/Foz2TWBoYb3F1MXJy
	SAiYSDRNmcEMYYtJXLi3nq2LkYtDSGA6o8SCxh5WCKeNSeL1399MIFVsApoS76dcYQGxRQQi
	JM4um8UCUsQscIpZYv3pP2AJYQEbiffPvoGNZRFQlejY+BHM5hVwk5j8rgNoBQfQOgWJOZNs
	JjByL2BkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHNfPpHcwrmqwOMQowMGoxMN7gzcm
	RIg1say4MvcQowQHs5IIrw07UIg3JbGyKrUoP76oNCe1+BCjKdDyicxSosn5wJSTVxJvaGxi
	ZmRpZG5oYWRsriTOe7DVOlBIID2xJDU7NbUgtQimj4mDU6qBUemuWPaf4Hn7d3S75ElGayhv
	n/usvKK9pd1zBcex8GvyJe7ziz9EnSt8wnDszoWma/yqhmVBWdfmzrF/W24yWbzWzf42n8nE
	e+leN0zsD1q3s+5htffe4Nt9tuC2Q3X2+mr7hLYNS5XjyzMvv9q59RzjRN0Qm8IHPcv3mzx8
	c/Cd5Ye6zi8MSizFGYmGWsxFxYkAahfCbwEDAAA=
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

Beomho Seo (5):
  mfd: rt5033: Add Rictek RT5033 driver core.
  regulator: rt5033: Add RT5033 Regulator device driver
  power: rt5033_battery: Add RT5033 Fuel gauge device driver
  power: rt5033_charger: Add RT5033 charger device driver
  Documentation: Add documentation for rt5033 multifunction device

 Documentation/devicetree/bindings/mfd/rt5033.txt   |  115 +++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/mfd/Kconfig                                |   11 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/rt5033.c                               |  157 +++++++
 drivers/power/Kconfig                              |   16 +
 drivers/power/Makefile                             |    2 +
 drivers/power/rt5033_battery.c                     |  189 ++++++++
 drivers/power/rt5033_charger.c                     |  485 ++++++++++++++++++++
 drivers/regulator/Kconfig                          |    8 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/rt5033-regulator.c               |  154 +++++++
 include/linux/mfd/rt5033-private.h                 |  255 ++++++++++
 include/linux/mfd/rt5033.h                         |   64 +++
 14 files changed, 1459 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt
 create mode 100644 drivers/mfd/rt5033.c
 create mode 100644 drivers/power/rt5033_battery.c
 create mode 100644 drivers/power/rt5033_charger.c
 create mode 100644 drivers/regulator/rt5033-regulator.c
 create mode 100644 include/linux/mfd/rt5033-private.h
 create mode 100644 include/linux/mfd/rt5033.h

-- 
1.7.9.5


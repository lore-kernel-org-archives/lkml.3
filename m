Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbaKSEwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 23:52:49 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:53273 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbaKSEwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 23:52:46 -0500
X-AuditID: cbfee68f-f791c6d000004834-aa-546c221ce9ff
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: sameo@linux.intel.com, lee.jone@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, cw00.choi@samsung.com, geunsik.lim@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        Beomho Seo <beomho.seo@samsung.com>
Subject: [PATCH v5 0/4] mfd: rt5033: Add Richtek RT5033 drivers
Date: Wed, 19 Nov 2014 13:52:36 +0900
Message-id: <1416372760-2090-1-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWyRsSkRFdGKSfEoHMvm8XpT9vYLaY+fMJm
	cf3Lc1aLSU/eM1vMP3KO1WLiysnMFv1vFrJa/JnQymZx7tVKRotJ9yewWLzfc4bR4tuVDiaL
	y7vmsFl87j3CaLH0+kUmiwnT17JYtO49wm5xupvV4vTuEosZk1+yOYh4rJm3htHjcl8vk8fO
	WXfZPVYu/8LmsXmFlsemVZ1sHneu7WHzmHcy0KNvyypGj8+b5AK4orhsUlJzMstSi/TtErgy
	bjzQK2gWrtj+cSNjA+NUvi5GDg4JAROJH3fCuhg5gUwxiQv31rN1MXJxCAksZZRY0n2SESJh
	IrHlxR02EFtIYDqjxPPJJhBFbUwSd47+ZwVJsAloSryfcoUFxBYRiJA4u2wWC0gRs8AkZomb
	b3vAJgkL2Eu0Pb8NZrMIqErsu/+XEeQKXgFXiSMzDSEOUpCYM8kGpFVCoJFDYu65XjaIcgGJ
	b5MPsUDUyEpsOsAMcZukxMEVN1gmMAouYGRYxSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iREY
	Xaf/PevfwXj3gPUhRgEORiUe3hdvs0OEWBPLiitzDzGaAm2YyCwlmpwPjOG8knhDYzMjC1MT
	U2Mjc0szJXHehVI/g4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwVp8sm/Nq6aR2FnvWBcHC
	wgF7bzAyNrFw9ex69Tr52/o9lt11qVqGmW4HFSZq/E5U9mya5jTvyI8yY5mr4tlBSyNWy8ft
	v1l8h6Nbm13r6v6/z0q0lGoPdu753Ph6ldjkky5WJ1yVPG+/8wnunVhwJ2ZRtkT7rOaJhZ1e
	1am7gems/ojSgwtKLMUZiYZazEXFiQA9u1JOqQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jQV1ppZwQg2vPrSxOf9rGbjH14RM2
	i+tfnrNaTHryntli/pFzrBYTV05mtuh/s5DV4s+EVjaLc69WMlpMuj+BxeL9njOMFt+udDBZ
	XN41h83ic+8RRoul1y8yWUyYvpbFonXvEXaL092sFqd3l1jMmPySzUHEY828NYwel/t6mTx2
	zrrL7rFy+Rc2j80rtDw2repk87hzbQ+bx7yTgR59W1YxenzeJBfAFdXAaJORmpiSWqSQmpec
	n5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9J2SQlliTilQKCCxuFhJ3w7T
	hNAQN10LmMYIXd+QILgeIwM0kLCGMePGA72CZuGK7R83MjYwTuXrYuTkkBAwkdjy4g4bhC0m
	ceHeejBbSGA6o8TzySZdjFxAdhuTxJ2j/1lBEmwCmhLvp1xhAbFFBCIkzi6bxQJSxCwwiVni
	5tseRpCEsIC9RNvz22A2i4CqxL77f4FsDg5eAVeJIzMNQUwJAQWJOZNsJjByL2BkWMUomlqQ
	XFCclJ5rqFecmFtcmpeul5yfu4kRHL3PpHYwrmywOMQowMGoxMP74m12iBBrYllxZe4hRgkO
	ZiURXsFuoBBvSmJlVWpRfnxRaU5q8SFGU6DdE5mlRJPzgYklryTe0NjEzMjSyNzQwsjYXEmc
	90CrdaCQQHpiSWp2ampBahFMHxMHp1QDo+3KxNfbL1fcZP62eF3oq2uGvRZqK/m/Fqc5HZA3
	PztnvWJmipqxfrll31xnT5fOWeJt3IXTTK/xOexJnZu/6N2OdPamEu3A9TNPH/y6YPXcuAer
	tqw82zSptnjLzao/pua/pA19Uo/92GmxZVEQ24Gvxa+PVz0+MP/suZi9dgc/P12yReX4hStK
	LMUZiYZazEXFiQAK4dMI9AIAAA==
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

Changes in v5
- Change possible built as a module.
- Revise rt5033_dev mfd cell entry.
- Fix incorrect typo.
- Add module alias.

Changes in v4
- rt5033 regulator patch is applied by Mark Brown.

Changes in v3
- Correct sentence errors.
- Add author information the top of each drivers.
- Remove unnecessary pre-initialise, struct member(rt5033->i2c) and blink.
- Change some return check.
- Use bool and of_match_ptr().

Changes in v2:
- Remove volatile_reg callback. Because this driver not in use regmap cache.
- Remove unnecessary subnode of_compatible.
- Add definde for set high impedance mode of charger.
- Remove unnecessary device specific code.
- Fix wrong register name.
- Fix wrong error message.
- Fix return vallue at error case.
- Revise binding documentation.

Beomho Seo (4):
  mfd: rt5033: Add Richtek RT5033 driver core.
  power: rt5033_battery: Add RT5033 Fuel gauge device driver
  power: rt5033_charger: Add RT5033 charger device driver
  Documentation: Add documentation for rt5033 multifunction device

 Documentation/devicetree/bindings/mfd/rt5033.txt   |  108 +++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/mfd/Kconfig                                |   12 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/rt5033.c                               |  136 ++++++
 drivers/power/Kconfig                              |   16 +
 drivers/power/Makefile                             |    2 +
 drivers/power/rt5033_battery.c                     |  177 +++++++
 drivers/power/rt5033_charger.c                     |  485 ++++++++++++++++++++
 include/linux/mfd/rt5033-private.h                 |  260 +++++++++++
 include/linux/mfd/rt5033.h                         |   62 +++
 11 files changed, 1260 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt
 create mode 100644 drivers/mfd/rt5033.c
 create mode 100644 drivers/power/rt5033_battery.c
 create mode 100644 drivers/power/rt5033_charger.c
 create mode 100644 include/linux/mfd/rt5033-private.h
 create mode 100644 include/linux/mfd/rt5033.h

-- 
1.7.9.5


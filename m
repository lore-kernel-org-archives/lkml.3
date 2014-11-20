Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbaKTNQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:16:54 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:56922 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaKTNQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:16:50 -0500
X-AuditID: cbfee68e-f79b46d000002b74-4b-546de9c07bc2
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
Subject: [PATCH v6 0/4] mfd: rt5033: Add Richtek RT5033 drivers
Date: Thu, 20 Nov 2014 22:16:42 +0900
Message-id: <1416489406-12416-1-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsWyRsSkWPfAy9wQgyXHRCxOf9rGbjH14RM2
	i+tfnrNaTHryntli/pFzrBYTV05mtuh/s5DV4s+EVjaLc69WMlpMuj+BxeL9njOMFt+udDBZ
	XN41h83ic+8RRoul1y8yWUyYvpbFonXvEXaL092sFqd3l1jMmPySzUHEY828NYwel/t6mTx2
	zrrL7rFy+Rc2j80rtDw2repk87hzbQ+bx7yTgR59W1YxenzeJBfAFcVlk5Kak1mWWqRvl8CV
	MX39X/aCg8IVndM3MjYwHubrYuTkkBAwkTi2Yxc7hC0mceHeerYuRi4OIYGljBL/DkxmhSlq
	O72PBSIxnVHi6LEzUFVtTBKdn2aAtbMJaEq8n3KFBcQWEYiQOLtsFlgHs8AkZombb3sYQRLC
	AvYSsx+cYgOxWQRUJfae7GDuYuTg4BVwk9j/SRrElBBQkJgzyQakVUKgkUPi2ZM1LBDlAhLf
	Jh9igaiRldh0gBniOEmJgytusExgFFzAyLCKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIzDG
	Tv971reD8eYB60OMAhyMSjy8CRa5IUKsiWXFlbmHGE2BNkxklhJNzgdGcl5JvKGxmZGFqYmp
	sZG5pZmSOG+C1M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYz+l7ee9eX5dOAr87Hrl/h2
	TA6SDmr6/e9Jf7/X9of6d+/VNltvaH418dKbvfPCHFaoXO9cUpuV8iH7zhGe2fsP6M8MuGqy
	Yj9b3rLubZdYJpQuuJRyLPh7Y3ehUtC6jbsnPc6bFPP1JTOf7nV28Xfz8jWOPn9adSM3XHP3
	8bBDsRcbGLp5juf7K7EUZyQaajEXFScCAOpZ686sAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jQd0DL3NDDLp3c1mc/rSN3WLqwyds
	Fte/PGe1mPTkPbPF/CPnWC0mrpzMbNH/ZiGrxZ8JrWwW516tZLSYdH8Ci8X7PWcYLb5d6WCy
	uLxrDpvF594jjBZLr19kspgwfS2LReveI+wWp7tZLU7vLrGYMfklm4OIx5p5axg9Lvf1Mnns
	nHWX3WPl8i9sHptXaHlsWtXJ5nHn2h42j3knAz36tqxi9Pi8SS6AK6qB0SYjNTEltUghNS85
	PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6DslhbLEnFKgUEBicbGSvh2m
	CaEhbroWMI0Rur4hQXA9RgZoIGENY8b09X/ZCw4KV3RO38jYwHiYr4uRk0NCwESi7fQ+Fghb
	TOLCvfVsXYxcHEIC0xkljh47A+W0MUl0fprBDlLFJqAp8X7KFbAOEYEIibPLZrGAFDELTGKW
	uPm2hxEkISxgLzH7wSk2EJtFQFVi78kO5i5GDg5eATeJ/Z+kQUwJAQWJOZNsJjByL2BkWMUo
	mlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHMHPpHYwrmywOMQowMGoxMObYJEbIsSaWFZcmXuI
	UYKDWUmEV2MnUIg3JbGyKrUoP76oNCe1+BCjKdDuicxSosn5wOSSVxJvaGxiZmRpZG5oYWRs
	riTOe+MmUJNAemJJanZqakFqEUwfEwenVAPjhk/z8mwfHbz4+Yqy7rFZZ+VFJ2etieIXFVY7
	z/Wr8alTctsHu51vqrKeC//qqdotWpV1o5a/bE6O0o2JX1d3WR3knTQ1mWHWhqXnz0QsSNn0
	d/9rvuTaphlleacVK3/KLjkQHfH+5B+FiQrR+2QL5j6uNnZrsp+jJTM/7t/J56USTtpKkxzj
	lViKMxINtZiLihMBkx+RIvYCAAA=
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

Changes in v6
- Fix white space issue in mfd cell struct.

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
 drivers/mfd/rt5033.c                               |  141 ++++++
 drivers/power/Kconfig                              |   16 +
 drivers/power/Makefile                             |    2 +
 drivers/power/rt5033_battery.c                     |  177 +++++++
 drivers/power/rt5033_charger.c                     |  485 ++++++++++++++++++++
 include/linux/mfd/rt5033-private.h                 |  260 +++++++++++
 include/linux/mfd/rt5033.h                         |   62 +++
 11 files changed, 1265 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt
 create mode 100644 drivers/mfd/rt5033.c
 create mode 100644 drivers/power/rt5033_battery.c
 create mode 100644 drivers/power/rt5033_charger.c
 create mode 100644 include/linux/mfd/rt5033-private.h
 create mode 100644 include/linux/mfd/rt5033.h

-- 
1.7.9.5


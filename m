Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbbAWFFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:05:53 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14407 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbbAWFDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:03:17 -0500
X-AuditID: cbfee68f-f791c6d000004834-c8-54c1d60554ee
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Inki Dae <inki.dae@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sebastian Reichel <sre@kernel.org>, Mark Brown <broonie@kernel.org>,
        Beomho Seo <beomho.seo@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH 0/6] Add new MFD driver for MAX77843
Date: Fri, 23 Jan 2015 14:02:41 +0900
Message-id: <1421989367-32721-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWyRsSkWJf12sEQg6PbLSxOf9rGbjH14RM2
	i+tfnrNazD9yjtWi/81CVotzr1YyWky6P4HFYkfDEVaL+1+PMlpc3jWHzeJz7xFGi6XXLzJZ
	TJi+lsWide8RdovTu0sc+D3WzFvD6HG5r5fJY+XyL2wem1Z1snncubaHzaNvyypGj8+b5ALY
	o7hsUlJzMstSi/TtErgynh70KmgSqFgyWamBsZu7i5GDQ0LARGL7zeIuRk4gU0ziwr31bF2M
	XBxCAksZJQ6c2MAMU7PjjwpEfDqjRN++DhYIp41JouPDQnaQbjYBbYnv6xezgtgiAhESzz+u
	ZAYpYhY4yCzRcfE0WJEwyLbu+cwgNouAqsTu5RMZQWxeAQ+JuTOfQm1TkJgzyQakV0LgGLvE
	6r8fGCHqBSS+TT7EAlEjK7HpADPE1ZISB1fcYJnAKLiAkWEVo2hqQXJBcVJ6kbFecWJucWle
	ul5yfu4mRmBMnP73rH8H490D1ocYBTgYlXh4G7YcDBFiTSwrrsw9xGgKtGEis5Rocj4w8vJK
	4g2NzYwsTE1MjY3MLc2UxHkXSv0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDoq/83O5H9
	1YpTVkXe8Twe0mWsDpK2f7m7O692bNj6n/3nqriZZ8oV8ndOnCjefVLZ/qDO/4evE+adrPPf
	dSLEdGsmj+WJ+up/HSWGUw7mfaqXndCdtizheeB1prZPh1pm1q24sy/A567Dy9LvTVUVKhIb
	Zno+5wtZni5Z3T3po6jEnn0156YosRRnJBpqMRcVJwIArzM23YQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jQV3WawdDDP5ON7A4/Wkbu8XUh0/Y
	LK5/ec5qMf/IOVaL/jcLWS3OvVrJaDHp/gQWix0NR1gt7n89ymhxedccNovPvUcYLZZev8hk
	MWH6WhaL1r1H2C1O7y5x4PdYM28No8flvl4mj5XLv7B5bFrVyeZx59oeNo++LasYPT5vkgtg
	j2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOlxJ
	oSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmPH0oFdBk0DFkslKDYzd3F2M
	HBwSAiYSO/6odDFyApliEhfurWfrYuTiEBKYzijRt6+DBcJpY5Lo+LCQHaSKTUBb4vv6xawg
	tohAhMTzjyuZQYqYBQ4yS3RcPA1WJAw0dXv3fGYQm0VAVWL38omMIDavgIfE3JlPmSE2K0jM
	mWQzgZF7ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgmHsmvYNxVYPFIUYBDkYlHt6G
	LQdDhFgTy4orcw8xSnAwK4nwPjkAFOJNSaysSi3Kjy8qzUktPsRoCrR8IrOUaHI+MB3klcQb
	GpuYGVkamRtaGBmbK4nzKtm3hQgJpCeWpGanphakFsH0MXFwSjUwOr+322vgVhT68P7Gp1f3
	18g3lFYZL3Gssyy6sJdBy+hBgM4vh6oNJSGLl2hP3q5206V495GDp48kHe5TrksolFGY5rI8
	dN5VrjsdryK+1PgxloTtvJ48I7JrSnHso4PzwiPjDoWybfTPVHe4KOA+/1Vb46bejMZpxQLR
	5+ZWTf4UKxH11HKdEktxRqKhFnNRcSIAeYQwRc8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds MAX77843(Multi Function Device) driver.
The MAX77843 includes MUIC(Micro USB Interface Circuit), Li+ Charger
with Fuel Gauge and 2 safeout LDOs for USB device.
It is interfaced to host controller using I2C.

Beomho Seo (2):
  power: max77843_charger: Add Max77843 charger device driver
  power: max77843_battery: Add Max77843 fuel gauge device driver

Jaewon Kim (4):
  mfd: max77843: Add max77843 MFD driver core driver
  extcon: max77843: Add max77843 MUIC driver
  regulator: max77843: Add max77843 regulator driver
  Documentation: Add device tree bindings document for max77843

 Documentation/devicetree/bindings/mfd/max77843.txt |   87 ++
 drivers/extcon/Kconfig                             |   10 +
 drivers/extcon/Makefile                            |    1 +
 drivers/extcon/extcon-max77843.c                   |  871 ++++++++++++++++++++
 drivers/mfd/Kconfig                                |   14 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/max77843.c                             |  241 ++++++
 drivers/power/Kconfig                              |   16 +
 drivers/power/Makefile                             |    2 +
 drivers/power/max77843_battery.c                   |  283 +++++++
 drivers/power/max77843_charger.c                   |  506 ++++++++++++
 drivers/regulator/Kconfig                          |    8 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/max77843.c                       |  259 ++++++
 include/linux/mfd/max77843-private.h               |  410 +++++++++
 15 files changed, 2710 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/max77843.txt
 create mode 100644 drivers/extcon/extcon-max77843.c
 create mode 100644 drivers/mfd/max77843.c
 create mode 100644 drivers/power/max77843_battery.c
 create mode 100644 drivers/power/max77843_charger.c
 create mode 100644 drivers/regulator/max77843.c
 create mode 100644 include/linux/mfd/max77843-private.h

-- 
1.7.9.5


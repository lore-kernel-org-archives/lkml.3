Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbaKLMId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 07:08:33 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:13238 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaKLMI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 07:08:29 -0500
X-AuditID: cbfee68e-f79b46d000002b74-63-54634dba4809
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
Subject: [PATCH v3 0/5] mfd: rt5033: Add Richtek RT5033 drivers
Date: Wed, 12 Nov 2014 21:07:57 +0900
Message-id: <1415794082-30277-1-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsWyRsSkQHe3b3KIwZ/LzBanP21jt5j68Amb
	xfUvz1ktJj15z2wx/8g5VouJKyczW/S/Wchq8WdCK5vFuVcrGS0m3Z/AYvF+zxlGi29XOpgs
	Lu+aw2bxufcIo8XS6xeZLCZMX8ti0br3CLvF6W5Wi9O7SyxmTH7J5iDisWbeGkaPy329TB47
	Z91l91i5/Aubx+YVWh6bVnWyedy5tofNY97JQI++LasYPT5vkgvgiuKySUnNySxLLdK3S+DK
	6F/1iq3guXBFd59LA+MBvi5GTg4JAROJBydOM0LYYhIX7q1n62Lk4hASWMoo8Xv5VXaYol9N
	r1kgEtMZJSZdOcAI4bQxSdy9eBisik1AU+L9lCssILaIQITE2WWzwDqYBSYxS9x82wO2Q1jA
	XuJu024wm0VAVeLd9rusIDavgJvEysezmboYOYDWKUjMmWQD0ish0Mgh8fP0KmaIegGJb5MP
	sUDUyEpsOsAMcZ2kxMEVN1gmMAouYGRYxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iREYY6f/
	PevbwXjzgPUhRgEORiUe3ozNSSFCrIllxZW5hxhNgTZMZJYSTc4HRnJeSbyhsZmRhamJqbGR
	uaWZkjhvgtTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2Miwwqg6+q7jVOWd87/8jMqfJ6
	s5sZRCZHL1AM6/SsL/7w4V4mo/nh/fLeCmwVS3JNYj++nTxtS3f3d/vrIuYq3a0ajO6z8v03
	Oac9ltxv1Onvf2WbTvxVz5aIe4teBF9j+6l0Rez1e3fln63HJUWXKj1hkjO2qthjW21xXsFj
	tRHLy8a5ef+UWIozEg21mIuKEwFTt+O4rAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jQd1dvskhBhebzC1Of9rGbjH14RM2
	i+tfnrNaTHryntli/pFzrBYTV05mtuh/s5DV4s+EVjaLc69WMlpMuj+BxeL9njOMFt+udDBZ
	XN41h83ic+8RRoul1y8yWUyYvpbFonXvEXaL092sFqd3l1jMmPySzUHEY828NYwel/t6mTx2
	zrrL7rFy+Rc2j80rtDw2repk87hzbQ+bx7yTgR59W1YxenzeJBfAFdXAaJORmpiSWqSQmpec
	n5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9J2SQlliTilQKCCxuFhJ3w7T
	hNAQN10LmMYIXd+QILgeIwM0kLCGMaN/1Su2gufCFd19Lg2MB/i6GDk5JARMJH41vWaBsMUk
	Ltxbz9bFyMUhJDCdUWLSlQOMEE4bk8Tdi4fZQarYBDQl3k+5AtYhIhAhcXbZLBaQImaBScwS
	N9/2MIIkhAXsJe427QazWQRUJd5tv8sKYvMKuEmsfDybqYuRA2idgsScSTYTGLkXMDKsYhRN
	LUguKE5KzzXUK07MLS7NS9dLzs/dxAiO4GdSOxhXNlgcYhTgYFTi4eV0SA4RYk0sK67MPcQo
	wcGsJMJ73RUoxJuSWFmVWpQfX1Sak1p8iNEUaPlEZinR5HxgcskriTc0NjEzsjQyN7QwMjZX
	Euc90GodKCSQnliSmp2aWpBaBNPHxMEp1cDIbORbLrFPsiVf7dv+SWYr0l3aNiZMMXuw/FLJ
	oYt9Ppl2N4OZ+CynPpkQNL0pr2PVx9SY/b6n7iw+evM/h9eGTgHjoPzcPas+fkmOuq3D95cv
	prH/94vLh/7LPV3Xk3NnjuiHBhWHS/cuipY6Ze20s3n3qKTMW4pDJWFrm9Ha2TkrCh2vPotT
	YinOSDTUYi4qTgQA1V8MJvYCAAA=
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

Beomho Seo (5):
  mfd: rt5033: Add Richtek RT5033 driver core.
  regulator: rt5033: Add RT5033 Regulator device driver
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
 drivers/regulator/Kconfig                          |    8 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/rt5033-regulator.c               |  123 +++++
 include/linux/mfd/rt5033-private.h                 |  260 +++++++++++
 include/linux/mfd/rt5033.h                         |   62 +++
 14 files changed, 1397 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt
 create mode 100644 drivers/mfd/rt5033.c
 create mode 100644 drivers/power/rt5033_battery.c
 create mode 100644 drivers/power/rt5033_charger.c
 create mode 100644 drivers/regulator/rt5033-regulator.c
 create mode 100644 include/linux/mfd/rt5033-private.h
 create mode 100644 include/linux/mfd/rt5033.h

-- 
1.7.9.5


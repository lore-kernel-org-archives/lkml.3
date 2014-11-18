Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbaKRN3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 08:29:24 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36123 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbaKRN3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 08:29:21 -0500
X-AuditID: cbfee691-f79b86d000004a5a-3f-546b49afd402
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
Subject: [PATCH v4 0/4] mfd: rt5033: Add Richtek RT5033 drivers
Date: Tue, 18 Nov 2014 22:29:13 +0900
Message-id: <1416317357-7538-1-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsWyRsSkQHe9Z3aIwdyD0hanP21jt5j68Amb
	xfUvz1ktJj15z2wx/8g5VouJKyczW/S/Wchq8WdCK5vFuVcrGS0m3Z/AYvF+zxlGi29XOpgs
	Lu+aw2bxufcIo8XS6xeZLCZMX8ti0br3CLvF6W5Wi9O7SyxmTH7J5iDisWbeGkaPy329TB47
	Z91l91i5/Aubx+YVWh6bVnWyedy5tofNY97JQI++LasYPT5vkgvgiuKySUnNySxLLdK3S+DK
	6F/3nangt2DF3CXdjA2Ma3i7GDk5JARMJCaf2cMEYYtJXLi3nq2LkYtDSGApo8Sm4++ZYIpO
	f54FlZjOKPFh4U9WCKeNSeJQ8wdGkCo2AU2J91OusIDYIgIREmeXzWIBKWIWmMQscfNtD1iR
	sIC9xO7pjWBjWQRUJaY0TGcGsXkFXCXmPJkGFOcAWqcgMWeSDcTmRg6Jfb8FIcoFJL5NPsQC
	USIrsekAM0SJpMTBFTdYJjAKLmBkWMUomlqQXFCclF5kqlecmFtcmpeul5yfu4kRGGOn/z2b
	uIPx/gHrQ4wCHIxKPLwJU7NChFgTy4orcw8xmgJtmMgsJZqcD4zkvJJ4Q2MzIwtTE1NjI3NL
	MyVxXh3pn8FCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGHXc7LJ3hz1orX7sPmetgXay0pXd
	ngXdTxWPH3LwOnNsfVZLtslu1YiLOf/mT4jnOtW3IfP9DEHektsbBdsZs1Uby146e3Nkb08u
	cuRn2HP68QNPRu5NeqpmcYf5V5jz20sHrJwnuPDnh3W7f4qe517jeezH4XPrrt+3u/snatYp
	5ofl2Tdi25VYijMSDbWYi4oTAYr2jfGsAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQd31ntkhBmtmClqc/rSN3WLqwyds
	Fte/PGe1mPTkPbPF/CPnWC0mrpzMbNH/ZiGrxZ8JrWwW516tZLSYdH8Ci8X7PWcYLb5d6WCy
	uLxrDpvF594jjBZLr19kspgwfS2LReveI+wWp7tZLU7vLrGYMfklm4OIx5p5axg9Lvf1Mnns
	nHWX3WPl8i9sHptXaHlsWtXJ5nHn2h42j3knAz36tqxi9Pi8SS6AK6qB0SYjNTEltUghNS85
	PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6DslhbLEnFKgUEBicbGSvh2m
	CaEhbroWMI0Rur4hQXA9RgZoIGENY0b/uu9MBb8FK+Yu6WZsYFzD28XIySEhYCJx+vMsNghb
	TOLCvfVANheHkMB0RokPC3+yQjhtTBKHmj8wglSxCWhKvJ9yhQXEFhGIkDi7bBYLSBGzwCRm
	iZtve8CKhAXsJXZPb2QCsVkEVCWmNExnBrF5BVwl5jyZBhTnAFqnIDFnks0ERu4FjAyrGEVT
	C5ILipPScw31ihNzi0vz0vWS83M3MYJj+JnUDsaVDRaHGAU4GJV4eBOmZoUIsSaWFVfmHmKU
	4GBWEuE91w0U4k1JrKxKLcqPLyrNSS0+xGgKtHwis5Rocj4wveSVxBsam5gZWRqZG1oYGZsr
	ifMeaLUOFBJITyxJzU5NLUgtgulj4uCUamBsbT+/oDSdW/ASY+Hv4En37K5Ka8b8PvLX5qAc
	e+Uy9mrLH5+PfrG9eP7Gv54Zndz7WPwtF/1ynJEz9+jVu9U/ws7tTvuTP/0sT78Zu3G9x6U3
	h5X+Ofga8c9uNmm8xKPWnuDm8PjK+tnG+ZIJv2Ze8ZrF6P/XI+HuZS3HxFyFic8WmPiZfXVS
	YinOSDTUYi4qTgQA7zyjRfcCAAA=
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


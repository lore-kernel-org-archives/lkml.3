Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbaLIMED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 07:04:03 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58181 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991AbaLIMD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 07:03:58 -0500
X-AuditID: cbfee68d-f79296d000004278-da-5486e52b73bb
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
Subject: [PATCH v8 0/4] mfd: rt5033: Add Richtek RT5033 drivers
Date: Tue, 09 Dec 2014 21:03:50 +0900
Message-id: <1418126634-4781-1-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWyRsSkWFf7aVuIwZKD2hanP21jt5j68Amb
	xfUvz1ktJj15z2wx/8g5VouJKyczW/S/Wchq8WdCK5vFuVcrGS0m3Z/AYvF+zxlGi29XOpgs
	Lu+aw2bxufcIo8XS6xeZLCZMX8ti0br3CLvF6W5Wi9O7SyxmTH7J5iDisWbeGkaPy329TB47
	Z91l91i5/Aubx+YVWh6bVnWyedy5tofNY97JQI++LasYPT5vkgvgiuKySUnNySxLLdK3S+DK
	aP5ykrngl0jFhf3TWBoYL/N3MXJySAiYSDx++JERwhaTuHBvPVsXIxeHkMBSRomDCzYxwhTt
	X72KCSKxiFGiqX0+M4TTxiTxrW0pE0gVm4CmxPspV1hAbBGBCImzy2axgBQxC0xilrj5tgds
	lLCAvcTi7jZWEJtFQFXiz8HnYDavgKvEpy1TgRo4gNYpSMyZZAPSKyHwl13i9cJ2Joh6AYlv
	kw9B1chKbDrADHGdpMTBFTdYJjAKLmBkWMUomlqQXFCclF5kqFecmFtcmpeul5yfu4kRGGWn
	/z3r3cF4+4D1IUYBDkYlHl4Ny7YQIdbEsuLK3EOMpkAbJjJLiSbnA2M5ryTe0NjMyMLUxNTY
	yNzSTEmcV1HqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRp19jFvbzdzjinql1GYwdW4O
	mLf62m9FkUwDh0ea0im3jX4tWyD3u8f+1LbwIw9uR/Fv+nBBbvl+3Qk67HeyxExF71yS+b60
	w0nk3kGfZRMtD24VOnX8lvy5frf5637uucG0dHv7G1Yv5Tv5ejJp8Z/DJonWpVWf/sVmwK13
	tjo83l+rY+ZzGyWW4oxEQy3mouJEAFkRyxmtAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jAV3tp20hBjcmKVqc/rSN3WLqwyds
	Fte/PGe1mPTkPbPF/CPnWC0mrpzMbNH/ZiGrxZ8JrWwW516tZLSYdH8Ci8X7PWcYLb5d6WCy
	uLxrDpvF594jjBZLr19kspgwfS2LReveI+wWp7tZLU7vLrGYMfklm4OIx5p5axg9Lvf1Mnns
	nHWX3WPl8i9sHptXaHlsWtXJ5nHn2h42j3knAz36tqxi9Pi8SS6AK6qB0SYjNTEltUghNS85
	PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6DslhbLEnFKgUEBicbGSvh2m
	CaEhbroWMI0Rur4hQXA9RgZoIGENY0bzl5PMBb9EKi7sn8bSwHiZv4uRk0NCwERi/+pVTBC2
	mMSFe+vZuhi5OIQEFjFKNLXPZ4Zw2pgkvrUtBatiE9CUeD/lCguILSIQIXF22SwWkCJmgUnM
	Ejff9jCCJIQF7CUWd7exgtgsAqoSfw4+B7N5BVwlPm2ZCtTAAbROQWLOJJsJjNwLGBlWMYqm
	FiQXFCel5xrpFSfmFpfmpesl5+duYgTH8DPpHYyrGiwOMQpwMCrx8GpYtoUIsSaWFVfmHmKU
	4GBWEuGdchQoxJuSWFmVWpQfX1Sak1p8iNEUaPlEZinR5HxgeskriTc0NjEzsjQyN7QwMjZX
	EudVsgdqEkhPLEnNTk0tSC2C6WPi4JRqYFy7/IzA6XMstWJSSof+31I7qPpa3zjdYau79ubp
	or/M+6pZxK2yuDtX5p5re6/l/tZ/re2Dxp0sV+T/NdmFqrD5BT1/31h8WSPgxsx6X8Mvj5Yn
	7TtiO/ejuKWT+ya/yPT0KaxTExP448t/KHEt2RJp/dRlvtib3pqFdryZNfWdPVpSak9clFiK
	MxINtZiLihMBDGMvHvcCAAA=
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

Changes in v8
- Add description of hardware.
- Move structure.

Changes in v7
- Use small description.
- Change some names for a variable.
- Revise of_device_id struct style.

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
 drivers/mfd/rt5033.c                               |  142 ++++++
 drivers/power/Kconfig                              |   16 +
 drivers/power/Makefile                             |    2 +
 drivers/power/rt5033_battery.c                     |  177 +++++++
 drivers/power/rt5033_charger.c                     |  485 ++++++++++++++++++++
 include/linux/mfd/rt5033-private.h                 |  260 +++++++++++
 include/linux/mfd/rt5033.h                         |   62 +++
 11 files changed, 1266 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/rt5033.txt
 create mode 100644 drivers/mfd/rt5033.c
 create mode 100644 drivers/power/rt5033_battery.c
 create mode 100644 drivers/power/rt5033_charger.c
 create mode 100644 include/linux/mfd/rt5033-private.h
 create mode 100644 include/linux/mfd/rt5033.h

-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298AbaLBNkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:40:05 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58038 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbaLBNj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:39:56 -0500
X-AuditID: cbfee691-f79b86d000004a5a-72-547dc1299afc
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
Subject: [PATCH v7 0/4] mfd: rt5033: Add Richtek RT5033 drivers
Date: Tue, 02 Dec 2014 22:39:47 +0900
Message-id: <1417527591-20450-1-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWyRsSkQFfzYG2Iwa25PBanP21jt5j68Amb
	xfUvz1ktJj15z2wx/8g5VouJKyczW/S/Wchq8WdCK5vFuVcrGS0m3Z/AYvF+zxlGi29XOpgs
	Lu+aw2bxufcIo8XS6xeZLCZMX8ti0br3CLvF6W5Wi9O7SyxmTH7J5iDisWbeGkaPy329TB47
	Z91l91i5/Aubx+YVWh6bVnWyedy5tofNY97JQI++LasYPT5vkgvgiuKySUnNySxLLdK3S+DK
	WLpvAkvBNpGK3V+3szcwzufvYuTkkBAwkXi77DErhC0mceHeerYuRi4OIYGljBKfWw+ywxSt
	eLyIGSKxiFFi47k/7BBOG5PEpHdrmECq2AQ0Jd5PucICYosIREicXTaLBaSIWWASs8TNtz2M
	IAlhAXuJ48fugI1lEVCVeNy8HqyZV8BN4t+JNiCbA2idgsScSTYgvRICrRwSMxd9ZYWoF5D4
	NvkQC0SNrMSmA8wQ10lKHFxxg2UCo+ACRoZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGIFR
	dvrfs4k7GO8fsD7EKMDBqMTDe+J8TYgQa2JZcWXuIUZToA0TmaVEk/OBsZxXEm9obGZkYWpi
	amxkbmmmJM6rI/0zWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANjazz3EqkzxXxTb9ytaL+W
	stCMKdNtaeiWspfGZn9kHu7WOat9o5SlQP6ry7zj52ZNs429+OacVUYBE6fUpJVPebu6XOo2
	vL/Ks+BVSTLfO9Xw/2ZXVoqJK9qc8nQsetO6b/mLe2eV3Q780VMU9pt63Cw68n9qz8ebKuVF
	T945mkq/eTlPhu2vEktxRqKhFnNRcSIA1kVUY60CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jAV3Ng7UhBq9WMFmc/rSN3WLqwyds
	Fte/PGe1mPTkPbPF/CPnWC0mrpzMbNH/ZiGrxZ8JrWwW516tZLSYdH8Ci8X7PWcYLb5d6WCy
	uLxrDpvF594jjBZLr19kspgwfS2LReveI+wWp7tZLU7vLrGYMfklm4OIx5p5axg9Lvf1Mnns
	nHWX3WPl8i9sHptXaHlsWtXJ5nHn2h42j3knAz36tqxi9Pi8SS6AK6qB0SYjNTEltUghNS85
	PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6DslhbLEnFKgUEBicbGSvh2m
	CaEhbroWMI0Rur4hQXA9RgZoIGENY8bSfRNYCraJVOz+up29gXE+fxcjJ4eEgInEiseLmCFs
	MYkL99azdTFycQgJLGKU2HjuDzuE08YkMendGiaQKjYBTYn3U66wgNgiAhESZ5fNYgEpYhaY
	xCxx820PI0hCWMBe4vixO+wgNouAqsTj5vVgzbwCbhL/TrQB2RxA6xQk5kyymcDIvYCRYRWj
	aGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcAw/k97BuKrB4hCjAAejEg/vifM1IUKsiWXFlbmH
	GCU4mJVEeH8Z14YI8aYkVlalFuXHF5XmpBYfYjQFWj6RWUo0OR+YXvJK4g2NTcyMLI3MDS2M
	jM2VxHlv3MwNERJITyxJzU5NLUgtgulj4uCUamD0eiOlxpUjcCciSMfdwO/7gUc6BxpmsF3c
	+ivo+68OXQZbjrBbu+cJvl8otHMSU4l834EpAV8E/E7EtxuU/1sj/uOynde5DAO7/o12l8vZ
	t666ILM082B+iWpUytTtCVcXB6tr9JdFX3p7J68wvaX7z27zHRHiZ9RfZ57SePEtwr7vp7+N
	0X4lluKMREMt5qLiRAC+hd7z9wIAAA==
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


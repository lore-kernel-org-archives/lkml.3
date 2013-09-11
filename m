Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab3IKLOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:14:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26170 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab3IKLOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:14:50 -0400
X-AuditID: cbfee68e-b7f756d000004512-50-523050a8926e
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [RFC 0/4] Add basic support for ASV
Date: Wed, 11 Sep 2013 16:44:04 +0530
Message-id: <1378898048-25205-1-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsWyRsSkVndFgEGQwfGZGha9C66yWWx6fI3V
	4vKuOWwWM87vY7K43biCzaJ/YS+TxfoZr1ksjs1Ywmix8auHxZzp75gcuDzuXNvD5rF5Sb1H
	35ZVjB6PFrcwenzeJBfAGsVlk5Kak1mWWqRvl8CVsennJeaCrSIV22e9Y25g7BXoYuTkkBAw
	kbj/bykzhC0mceHeerYuRi4OIYGljBLzL6xlhCl6P/EqK0RiOqPEscOzWEASQgJtTBLXvul3
	MXJwsAkYSbw6ZgcSFhFQkNjc+wysnlngOZPE1z1z2UASwgI6EsumzgbrZRFQldj1AaSIk4NX
	wFWir/kbE8QyBYnWZYfYIex57BK7mgsh6gUkvk0+xAKyS0JAVmLTAaijJSUOrrjBMoFRcAEj
	wypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MwHA+/e9Z3w7GmwesDzEmA42byCwlmpwPjIe8
	knhDYzMjC1MTU2Mjc0sz0oSVxHnVWqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDmNFem
	7bXIDrp7pkece7pO6tfNv1i75ykeiPbYWN/Wu3v3DY8/tp3Fb6wevnnZMKn1hMXHTTnRs29v
	Cl0X2teTs+ATb8Ths/afL/OG3gz+xr7iklPvhstri5L/MK70u/mn319Nd6sJi2P6bbOYHRwp
	vja2rEc3HnHdLphecv+9g1BRsnDbrSglluKMREMt5qLiRADKim2zfQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t9jQd0VAQZBBmtOyln0LrjKZrHp8TVW
	i8u75rBZzDi/j8niduMKNov+hb1MFutnvGaxODZjCaPFxq8eFnOmv2Ny4PK4c20Pm8fmJfUe
	fVtWMXo8WtzC6PF5k1wAa1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJe
	Ym6qrZKLT4CuW2YO0FFKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoxN
	Py8xF2wVqdg+6x1zA2OvQBcjJ4eEgInE+4lXWSFsMYkL99azdTFycQgJTGeUOHZ4FgtIQkig
	jUni2jf9LkYODjYBI4lXx+xAwiICChKbe5+xgtQzCzxnkvi6Zy4bSEJYQEdi2dTZYL0sAqoS
	uz48A1vAK+Aq0df8jQlimYJE67JD7BMYuRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93E
	CI6XZ1I7GFc2WBxiFOBgVOLhvSGnHyTEmlhWXJl7iFGCg1lJhPeBqUGQEG9KYmVValF+fFFp
	TmrxIcZkoO0TmaVEk/OBsZxXEm9obGJuamxqaWJhYmZJmrCSOO+BVutAIYH0xJLU7NTUgtQi
	mC1MHJxSDYzNFyYI5l5inDeroEbl4ZvA84obd02cLacU3Niq/sV3Lsv0htPz4njv1RVmW/Ak
	Jp16H+P1Sqotim/5o+U9J/kKlvdFzdbIn3HLITleOvXK798MXDf++qpez7/e/2WxW7hM8ymp
	bwd+uuxJruz09PE+UJsSEXatIkT2+XkjvmWp4m8WXXfiOKDEUpyRaKjFXFScCAAwZEHc2wIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is to add basic common infrastructure for ASV.
 Basically ASV is a technique used on samsung SoCs, which provides the
recommended supply voltage for dvfs of arm, mif etc. For a given operating
frequency, the voltage is recommended based on SoC's ASV group.
ASV group gets fussed on SoCs during process of mass production.

This series includes:
 - basic common infrastructue for ASV. It provides common APIs for user drivers
like cpufreq & devfreq and and an interface for SoC specific drivers to
register ASV members(instances)
 - a common platform driver to register ASV members for exynos SoCs
 - an example providing minimal support (only for ARM ASV) for exynos5250 chips

Its just basic skelton which I wanted to get it reviewed or discussed in
early stage, before going ahead on further development based on it.
 Presently example is based on static ASV table provided in SoC specific file,
which I expects to go into DT. But exactly how and where needs to be discussed,
may be in next revisions once we get through the basic skelton.
 Also the location of driver in kernel may also seem odd to someone and
many more things :).

Looking for your valuable reviews and suggestions.

Thanks

Yadwinder Singh Brar (4):
  power: asv: Add common ASV support for samsung SoCs
  power: asv: Add a common asv driver for exynos SoCs.
  power: asv: Add support for exynos5250
  arm: exynos5: Register static platform device for ASV.

 arch/arm/mach-exynos/mach-exynos5-dt.c   |    3 +
 drivers/power/Kconfig                    |    1 +
 drivers/power/Makefile                   |    1 +
 drivers/power/asv/Kconfig                |   24 ++++
 drivers/power/asv/Makefile               |    2 +
 drivers/power/asv/exynos-asv.c           |   81 ++++++++++++++
 drivers/power/asv/exynos-asv.h           |   22 ++++
 drivers/power/asv/exynos5250-asv.c       |  141 ++++++++++++++++++++++++
 drivers/power/asv/samsung-asv.c          |  175 ++++++++++++++++++++++++++++++
 include/linux/power/samsung-asv-driver.h |   61 +++++++++++
 include/linux/power/samsung-asv.h        |   37 +++++++
 11 files changed, 548 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/asv/Kconfig
 create mode 100644 drivers/power/asv/Makefile
 create mode 100644 drivers/power/asv/exynos-asv.c
 create mode 100644 drivers/power/asv/exynos-asv.h
 create mode 100644 drivers/power/asv/exynos5250-asv.c
 create mode 100644 drivers/power/asv/samsung-asv.c
 create mode 100644 include/linux/power/samsung-asv-driver.h
 create mode 100644 include/linux/power/samsung-asv.h


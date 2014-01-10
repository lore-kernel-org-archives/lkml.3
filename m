Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaAJLlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 06:41:01 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:44085 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaAJLk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:40:59 -0500
X-AuditID: cbfee68e-b7f566d000002344-fe-52cfdc4903c2
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com
Subject: [PATCH 0/8 v3] crypto:s5p-sss: Add DT and Exynos support
Date: Fri, 10 Jan 2014 17:11:15 +0530
Message-id: <1389354075-31636-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWyRsSkStfzzvkgg54ZxhYvD2ladL+Ssbh/
	7yeTxeVdc9gsZpzfx2SxaNt/ZotVu/4wWpydc4jJgcNj56y77B7bDqh69G1ZxejxeZNcAEsU
	l01Kak5mWWqRvl0CV8axn8dYCi7wVbxd/ZipgXEVdxcjJ4eEgInE/a6jLBC2mMSFe+vZuhi5
	OIQEljJKnD+xjQmm6M3cFawQiemMEg0btjNDOP1MEusWH2YGqWITMJM4uGg1O4gtIuAs8bt5
	DVgHs8AcRomHS9rBdggLOErMnnUNbCyLgKrE9e9tQEUcHLwCrhLf73mCmBICChJzJtmAVHAK
	uEmcPnSRHSQsBFRx+EgayEQJgXnsEqu23WeGmCIg8W3yIRaIVlmJTQeYIW6WlDi44gbLBEbh
	BYwMqxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzECw/v0v2d9OxhvHrA+xJgMNG4is5Rocj4w
	PvJK4g2NzYwsTE1MjY3MLc1IE1YS5130MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6O/
	nfAdTr1p15OVmUNql8xprrH9vc898EbDZ+5Yof4QA147lZUpznE7d5vNY41RvBWUFxZ7qea4
	281Xm3Zv4BY5urDL7VD+Ei6lqT31gbxrb0v+jGh0cHlavO/3a/EjUj3/1oS0nJ1Qmf87aObr
	Vu6iWQ+Va8M/yO+rzd0itWK2WGj1e5nZ85RYijMSDbWYi4oTAfWhdp2FAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t9jQV3PO+eDDH5P0bZ4eUjTovuVjMX9
	ez+ZLC7vmsNmMeP8PiaLRdv+M1us2vWH0eLsnENMDhweO2fdZffYdkDVo2/LKkaPz5vkAlii
	GhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COUFIo
	S8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmHPt5jKXgAl/F29WPmRoYV3F3
	MXJySAiYSLyZu4IVwhaTuHBvPVsXIxeHkMB0RomGDduZIZx+Jol1iw8zg1SxCZhJHFy0mh3E
	FhFwlvjdvIYVpIhZYA6jxMMl7SwgCWEBR4nZs64xgdgsAqoS17+3ARVxcPAKuEp8v+cJYkoI
	KEjMmWQDUsEp4CZx+tBFdpCwEFDF4SNpExh5FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P
	3cQIjp5n0jsYVzVYHGIU4GBU4uEtmHU+SIg1say4MvcQowQHs5IIr/kFoBBvSmJlVWpRfnxR
	aU5q8SHGZKCTJjJLiSbnAyM7ryTe0NjE3NTY1NLEwsTMkjRhJXHeg63WgUIC6YklqdmpqQWp
	RTBbmDg4pRoYVXlverst41+1S4Hdse1MgHht9sfayfcEzB5Eru/uu7hTTe3uA/4q/wunZstc
	nyy39PL1pUe01vHVyk/N2d0tp7zVOk077111UKHHhvpoqdfzswyKHs5c/M1ALyTurHOSl5xY
	a+NJtwkB1rdece6fVvL7/HrHk4ob6150emS0S3SG2Uz/q+enxFKckWioxVxUnAgAHTHN+OIC	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SSS module on Exynos4210, Exynos5250 and Exynos5420 SoCs has added
features to the one on S5PV210. However minor changes to the s5p-sss.c
driver are required to support SSS modules on Exynos4 and 5 SoCs.

This patch set
1. Adds device tree support to the s5p-sss.c driver and Documentation
2. Adds code to support SSS module on Exynos4 and 5 SoCs
3. Adds device tree node to Exynos5250 and Exynos5420
4. Adds variant struct to handle the differences in SSS modules
5. Adds clk_prepare/clk_unprepare clocks to the s5p-sss.c driver

Note: Compatible "exynos4210-secss" should work for Exynos4412 and
      Exynos5260 (Exynos5260, for which ARCH code is under review)
I couldn't test on Exynos4412 and Exynos4210 boards, Should be able to
test with addition of DT node and clocks support.

Naveen Krishna Ch (6): [crypto-2.6.git]
  crypto:s5p-sss: Use platform_get_irq() instead of _byname()
  crypto:s5p-sss: Kconfig: Let Exynos SoCs select SSS driver
  crypto:s5p-sss: Add device tree support
  crypto:s5p-sss: Add support for SSS module on Exynos
  crypto:s5p-sss: validate iv before memcpy
  crypto:s5p-sss: Use clk_prepare/clk_unprepare

Naveen Krishna Chatradhi (2): [linuxsamsung.git]
  clk:exynos5250: Add gate clock for SSS module
  ARM: dts: exynos5250/5420: add dt node for sss module

 .../devicetree/bindings/crypto/samsung-sss.txt     |   40 ++++++
 arch/arm/boot/dts/exynos5250.dtsi                  |    8 ++
 arch/arm/boot/dts/exynos5420.dtsi                  |   10 ++
 drivers/clk/samsung/clk-exynos5250.c               |    3 +-
 drivers/crypto/Kconfig                             |    8 +-
 drivers/crypto/s5p-sss.c                           |  131 +++++++++++++++-----
 6 files changed, 165 insertions(+), 35 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt

-- 
1.7.9.5


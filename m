Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbaBQJpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:45:22 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29185 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaBQJpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:45:08 -0500
X-AuditID: cbfee690-b7f266d00000287c-b6-5301da224a5e
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, davem@davemloft.net
Subject: [PATCH 0/9 v7] crypto:s5p-sss: Add DT and Exynos support
Date: Mon, 17 Feb 2014 15:14:26 +0530
Message-id: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWyRsSkSlfpFmOwwZcbphYvD2lazDnfwmLR
	/UrG4v69n0wWl3fNYbOYcX4fk8Wibf+ZLc7OOcTkwOGxZeVNJo+ds+6ye2w7oOrRt2UVo8fn
	TXIBrFFcNimpOZllqUX6dglcGXNvfGQvaBOsWL3zB2MD42TeLkZODgkBE4nNDzewQ9hiEhfu
	rWfrYuTiEBJYyijxfW8PC0zRkYVnGCESixglDnRdZoZw+pkk7uyCqGITMJM4uGg12CgRAWeJ
	381rWEGKmAVmMUrMvv+JESQhLOAo0Tp7KzOIzSKgKvGxcRlYM6+Ai8T3SxuYuhg5gNYpSMyZ
	ZAOxuZ1dYvZpS4hyAYlvkw+xQJTISmw6wAxRIilxcMUNlgmMggsYGVYxiqYWJBcUJ6UXmegV
	J+YWl+al6yXn525iBIbu6X/PJuxgvHfA+hBjMtC4icxSosn5wNDPK4k3NDYzsjA1MTU2Mrc0
	I01YSZxX7VFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGx2u8l96UK09PusQy9e3xbTyz
	LaIVox+FPd/mYDN/jtmvA/mMj/4zdVolF0+dNXXRaUuDooecdd982NvPHn6t0zxXIlK6o2FC
	dSSXZYI9q+VT8Q3MCRbP73+8yMvVHhTwsKFfTU7oinPdbq4PiiXyyt2dgdrPr8W5/2ZnuMQ8
	59aHySwNx/8psRRnJBpqMRcVJwIAk8CEmHMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t9jAV2lW4zBBvu26li8PKRpMed8C4tF
	9ysZi/v3fjJZXN41h81ixvl9TBaLtv1ntjg75xCTA4fHlpU3mTx2zrrL7rHtgKpH35ZVjB6f
	N8kFsEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
	AF2ipFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcyYe+Mje0GbYMXqnT8Y
	Gxgn83YxcnJICJhIHFl4hhHCFpO4cG89WxcjF4eQwCJGiQNdl5khnH4miTu7elhAqtgEzCQO
	LlrNDmKLCDhL/G5ewwpSxCwwi1Fi9v1PYKOEBRwlWmdvZQaxWQRUJT42LgNr5hVwkfh+aQNT
	FyMH0DoFiTmTbCYwci9gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERwbz6R3MK5qsDjE
	KMDBqMTD21nLGCzEmlhWXJl7iFGCg1lJhNd2HVCINyWxsiq1KD++qDQntfgQYzLQ8onMUqLJ
	+cC4zSuJNzQ2MTc1NrU0sTAxsyRNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGRm9fEfWJ
	1l3X/wRdapgQfevjbncR/ZlvBNd8cLsrbNwTGJa/pcNvXwBvldnzt/uX3P1hl6/3Nq/k48r/
	nGUzWOV0D9neZtZW5bgc7c2yM0D40xz+e8f36zosO+iTvddewuDkRj+mTz0l1rvkLOfHM+8p
	W8WfoHNVvlC1VOOHqMiymhvCVQv+KbEUZyQaajEXFScCAKoqiE7RAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SSS module on Exynos4210, Exynos5250 and Exynos5420 SoCs has added
features to the one on S5PV210. However with minor changes the s5p-sss.c
driver can be reused to support SSS modules on Exynos4 and 5 SoCs.

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

Naveen Krishna Ch (7): [crypto-2.6.git]
  crypto:s5p-sss: Use platform_get_irq() instead of _byname()
  crypto:s5p-sss: Kconfig: Let Exynos SoCs select SSS driver
  crypto:s5p-sss: Look for the next request in the queue
  crypto:s5p-sss: Add device tree support
  crypto:s5p-sss: Add support for SSS module on Exynos
  crypto:s5p-sss: validate iv before memcpy
  crypto:s5p-sss: Use clk_prepare/clk_unprepare

Naveen Krishna Chatradhi (1): [samsung-clk.git]
  clk: samsung exynos5250/5420: Add gate clock for SSS module

Naveen Krishna Chatradhi (1): [linuxsamsung.git]
  ARM: dts: exynos5250/5420: add dt node for sss module

 .../devicetree/bindings/clock/exynos5250-clock.txt |    1 +
 .../devicetree/bindings/crypto/samsung-sss.txt     |   35 +++++
 arch/arm/boot/dts/exynos5250.dtsi                  |    8 ++
 arch/arm/boot/dts/exynos5420.dtsi                  |    9 ++
 drivers/clk/samsung/clk-exynos5250.c               |    1 +
 drivers/clk/samsung/clk-exynos5420.c               |    4 +
 drivers/crypto/Kconfig                             |    6 +-
 drivers/crypto/s5p-sss.c                           |  145 +++++++++++++++-----
 include/dt-bindings/clock/exynos5250.h             |    1 +
 9 files changed, 174 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt

-- 
1.7.9.5


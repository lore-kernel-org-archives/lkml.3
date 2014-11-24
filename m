Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaKXCN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:13:29 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16495 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbaKXCMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:12:49 -0500
X-AuditID: cbfee691-f79b86d000004a5a-9c-5472941fae99
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH v4 5/5] arm: exynos: Select SOC_SAMSUNG config option
Date: Mon, 24 Nov 2014 07:36:15 +0530
Message-id: <1416794775-1605-6-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416794775-1605-1-git-send-email-amit.daniel@samsung.com>
References: <1416794775-1605-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWyRsSkVld+SlGIwd6H4hYNV0MsehdcZbPY
	9Pgaq8XlXXPYLGac38dkcfsyrwObR0tzD5vH5iX1Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+X
	wJXRdu84e8EF1orWaTOYGxgvsHQxcnJICJhInOx4zwxhi0lcuLeerYuRi0NIYCmjxKJd25lg
	ih6vOMcEkZjOKDF702VGCGcCk8S5qz/ZQKrYBIwlfu7cz97FyMEhIuAtsfyaIkgNs0ADo8T2
	D/PBaoQFXCV2fP3BCmKzCKhKHP83hxHE5hVwk1i36ikbSK+EgILEnEk2IGFOAXeJ5qPzwUqE
	gEr2fO8AO0JCoJtdYt+qr4wQcwQkvk0+xALRKyux6QDUN5ISB1fcYJnAKLyAkWEVo2hqQXJB
	cVJ6kalecWJucWleul5yfu4mRmAwn/73bOIOxvsHrA8xCnAwKvHwfmgtDBFiTSwrrsw9xGgK
	tGEis5Rocj4wZvJK4g2NzYwsTE1MjY3MLc2UxHl1pH8GCwmkJ5akZqemFqQWxReV5qQWH2Jk
	4uCUamAMvH9/o0EgwwcHRrfPYaGTZwjt/8eWXu4uGR/LlhVcecpq9+zaPs5N9VOW15y7IPD6
	ZULXsplngoR+zMiVELl98qNi2bMHj4xbTklN5nMpnLvYQ0+nSnv/p2WCctvuLv0zeUuA4dZc
	4aP9PyLvdb1gZ3zpKjl3zaOzfik2F3+sOi80fSfLS+ZZSizFGYmGWsxFxYkAl4O/JWECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsVy+t9jQV35KUUhBn3L+C0aroZY9C64ymax
	6fE1VovLu+awWcw4v4/J4vZlXgc2j5bmHjaPzUvqPfq2rGL0+LxJLoAlqoHRJiM1MSW1SCE1
	Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdotZJCWWJOKVAoILG4WEnf
	DtOE0BA3XQuYxghd35AguB4jAzSQsIYxo+3ecfaCC6wVrdNmMDcwXmDpYuTkkBAwkXi84hwT
	hC0mceHeerYuRi4OIYHpjBKzN11mhHAmMEmcu/qTDaSKTcBY4ufO/exdjBwcIgLeEsuvKYLU
	MAs0MEps/zAfrEZYwFVix9cfrCA2i4CqxPF/cxhBbF4BN4l1q56ygfRKCChIzJlkAxLmFHCX
	aD46H6xECKhkz/cOpgmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMfKM+kdjKsa
	LA4xCnAwKvHwfmwtDBFiTSwrrsw9xCjBwawkwnv2H1CINyWxsiq1KD++qDQntfgQoynQUROZ
	pUST84FxnFcSb2hsYm5qbGppYmFiZqkkznvjZm6IkEB6YklqdmpqQWoRTB8TB6dUA6Mnb8vZ
	AsuHUXpNj7u+686p/duofMeQpVFNQDXE17D6ZsC07z/vzkq02FQ374ZW5OWTR46m9iruznPe
	Jyz6VS99ypxDu5vM9yxWvL7p2z5Rpr74z1f8DN+XCQYw/FJ/pCcRc/526F9B2wdGsxr+BDNe
	0XY+n8Z1cY+Q4c4g07KnM9WezWBKyFBiKc5INNRiLipOBAB8V9Z5qwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The config option SOC_SAMSUNG is needed to enable all soc samsung
drivers inside driver/soc/samsung folder. Currently, this will be useful to
enable exynos pmu driver which is moved to that folder.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 arch/arm/mach-exynos/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index b9e3f1c..17880b6 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -25,6 +25,7 @@ menuconfig ARCH_EXYNOS
 	select S5P_DEV_MFC
 	select SRAM
 	select MFD_SYSCON
+	select SOC_SAMSUNG
 	help
 	  Support for SAMSUNG EXYNOS SoCs (EXYNOS4/5)
 
-- 
1.7.9.5


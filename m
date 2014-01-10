Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaAJLng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 06:43:36 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:35685 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbaAJLnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:43:33 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-eb-52cfdce41345
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com
Subject: [PATCH 5/8 v3] clk:exynos-5250: Add gate clock for SSS module
Date: Fri, 10 Jan 2014 17:13:49 +0530
Message-id: <1389354229-31936-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389095509-14357-6-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-6-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsWyRsSkWvfJnfNBBlP+c1u8PKRp0f1KxuL+
	vZ9MFpd3zWGzmHF+H5PFom3/mS1W7frDaHF2ziEmBw6PnbPusntsO6Dq0bdlFaPH501yASxR
	XDYpqTmZZalF+nYJXBl/LjxjKfjHVbH27gbGBsZJnF2MnBwSAiYSjbuXsEPYYhIX7q1n62Lk
	4hASWMoocXrlSWaYogstl1ghEosYJVaungHl9DNJNO96wQhSxSZgJnFw0WqwUSICzhK/m9eA
	FTELzGGUeLiknQUkISzgJvH8biMTiM0ioCrxadM5sDivgKvEvB0/gAZxAK1TkJgzyQYkzAlU
	PqvrHytIWAioZMb5dJCREgLz2CX6//5mgxgjIPFt8iEWiFZZiU0HoI6WlDi44gbLBEbhBYwM
	qxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzECA/z0v2e9OxhvH7A+xJgMNG4is5Rocj4wQvJK
	4g2NzYwsTE1MjY3MLc1IE1YS5016mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgdFTTydv
	r+JSKYtHUevXlOqL15s959uZqWX+88aO8ztTPBbNUE4XX5wpus6ux/SeVfR8CR6viU4rPC3q
	nd+5fCiaePPmlTCFkPtzgq6eDOixmnvj9I36hlCWT6sWn9SX59c6aPfmXLfTpOagT+Xx+gJa
	x8zPrHv/zi1gIoO4xtaawDuOd+RY7ZRYijMSDbWYi4oTAYAIMACGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jAd0nd84HGRyfz2zx8pCmRfcrGYv7
	934yWVzeNYfNYsb5fUwWi7b9Z7ZYtesPo8XZOYeYHDg8ds66y+6x7YCqR9+WVYwenzfJBbBE
	NTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAdoaRQ
	lphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM+HPhGUvBP66KtXc3MDYwTuLs
	YuTkkBAwkbjQcokVwhaTuHBvPVsXIxeHkMAiRomVq2ewQjj9TBLNu14wglSxCZhJHFy0mh3E
	FhFwlvjdvAasiFlgDqPEwyXtLCAJYQE3ied3G5lAbBYBVYlPm86BxXkFXCXm7fgBNIgDaJ2C
	xJxJNiBhTqDyWV3/WEHCQkAlM86nT2DkXcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMj
	OH6eSe1gXNlgcYhRgINRiYe3YNb5ICHWxLLiytxDjBIczEoivOYXgEK8KYmVValF+fFFpTmp
	xYcYk4FumsgsJZqcD4ztvJJ4Q2MTc1NjU0sTCxMzS9KElcR5D7RaBwoJpCeWpGanphakFsFs
	YeLglGpg9Pmol3m1SuWNoRPfo3221/ZdC096avY5x8L31ubPOzec3LBsR1tAjajNylwxi5nM
	+skJLxsXnL/f1Hzp7OY7ivr3+/9N6jy00lxruv17pd7FT9UNfnrfM1pfkLQ0reL/TzGlt7dP
	vmH5/M5u58H5519vVLhZYFO2713/jMALeUU8Ez1THvg1CCuxFGckGmoxFxUnAgDj35kw4wIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds gating clock for SSS(Security SubSystem)
module on Exynos5250.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v2:
This is a new change to support SSS on Exynos5250

 drivers/clk/samsung/clk-exynos5250.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
index adf3234..b47bf0a 100644
--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -120,7 +120,7 @@ enum exynos5250_clks {
 	spi2, i2s1, i2s2, pcm1, pcm2, pwm, spdif, ac97, hsi2c0, hsi2c1, hsi2c2,
 	hsi2c3, chipid, sysreg, pmu, cmu_top, cmu_core, cmu_mem, tzpc0, tzpc1,
 	tzpc2, tzpc3, tzpc4, tzpc5, tzpc6, tzpc7, tzpc8, tzpc9, hdmi_cec, mct,
-	wdt, rtc, tmu, fimd1, mie1, dsim0, dp, mixer, hdmi, g2d,
+	wdt, rtc, tmu, fimd1, mie1, dsim0, dp, mixer, hdmi, g2d, sss,
 
 	/* mux clocks */
 	mout_hdmi = 1024,
@@ -492,6 +492,7 @@ static struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
 	GATE(mixer, "mixer", "mout_aclk200_disp1", GATE_IP_DISP1, 5, 0, 0),
 	GATE(hdmi, "hdmi", "mout_aclk200_disp1", GATE_IP_DISP1, 6, 0, 0),
 	GATE(g2d, "g2d", "aclk200", GATE_IP_ACP, 3, 0, 0),
+	GATE(sss, "sss", "aclk200", GATE_IP_ACP, 2, 0, 0),
 };
 
 static struct samsung_pll_rate_table vpll_24mhz_tbl[] __initdata = {
-- 
1.7.9.5


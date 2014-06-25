Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbaFYKl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:41:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30708 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbaFYKlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:41:24 -0400
X-AuditID: cbfee68f-b7fef6d000003970-3e-53aaa7520da5
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, linux-arm-kernel@lists.infradead.org,
        sjg@chromium.org, linux-kernel@vger.kernel.org, wsa@the-dreams.de,
        cpgs@samsung.com, broonie@kernel.org
Subject: [PATCH 2/2] i2c: exynos5: fix minor styling nits
Date: Wed, 25 Jun 2014 16:08:17 +0530
Message-id: <1403692697-7381-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1403692697-7381-1-git-send-email-ch.naveen@samsung.com>
References: <1403692697-7381-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42JZI2JSoxu0fFWwwc0+OYupD5+wWbw8pGmx
	6fE1VouOv18YLS7vmsNmMeP8PiaLRdv+M1t827KN0WLliVnMDpwesxsusnjsnHWX3WPTqk42
	j81L6j36tqxi9Dh56gmLx+dNcgHsUVw2Kak5mWWpRfp2CVwZ85rvMxa85qj4tbSLpYFxFXsX
	IyeHhICJxNQrbxkhbDGJC/fWs3UxcnEICSxllHjZ+BWu6PG5lVCJRYwS51atY4Zw+pkkLvVd
	ZwOpYhMwkzi4aDVYh4iAg8S8td/ZQYqYBTYySuxZfoEVJCEsYCmxoO0z2D4WAVWJNVsusIDY
	vAIuEpu6NwA1cACtU5CYM8kGJMwp4CrxtekMM4gtBFTy5OImVpCZEgK72CUOTbrIBjFHQOLb
	5EMsEL2yEpsOMENcLSlxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXGesVJ+YWl+al6yXn525iBEbD
	6X/P+ncw3j1gfYgxGWjcRGYp0eR8YDTllcQbGpsZWZiamBobmVuakSasJM57/2FSkJBAemJJ
	anZqakFqUXxRaU5q8SFGJg5OqQbG9rvWC/cFfytY9igtvkrb6NnFG8ffM0ZUfmzsuNl1x13u
	yfPbv1fqPbsftFoxTq3z9ZXqZWumfC/+wLpk1uO2qcbncu3KG2/IGiVPV79uzlHO75tfLDFr
	3gPHG9Vmhzz2b8i9r9pwcLazTsmlg+zfuDRm7Ex/cG3FZJ8w/oWLIhXbGP/MeCVhqMRSnJFo
	qMVcVJwIAEq2rWucAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAd2g5auCDfb9ErWY+vAJm8XLQ5oW
	mx5fY7Xo+PuF0eLyrjlsFjPO72OyWLTtP7PFty3bGC1WnpjF7MDpMbvhIovHzll32T02repk
	89i8pN6jb8sqRo+Tp56weHzeJBfAHtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGto
	aWGupJCXmJtqq+TiE6DrlpkDdJmSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0
	kLCGMWNe833GgtccFb+WdrE0MK5i72Lk5JAQMJF4fG4lG4QtJnHh3nogm4tDSGARo8S5VeuY
	IZx+JolLfdfBqtgEzCQOLloN1i0i4CAxb+13dpAiZoGNjBJ7ll9gBUkIC1hKLGj7zAhiswio
	SqzZcoEFxOYVcJHY1L0BqIEDaJ2CxJxJNiBhTgFXia9NZ5hBbCGgkicXN7FOYORdwMiwilE0
	tSC5oDgpPddIrzgxt7g0L10vOT93EyM41p5J72Bc1WBxiFGAg1GJh/fC7JXBQqyJZcWVuYcY
	JTiYlUR4HeesChbiTUmsrEotyo8vKs1JLT7EaAp01ERmKdHkfGAayCuJNzQ2MTc1NrU0sTAx
	s1QS5z3Yah0oJJCeWJKanZpakFoE08fEwSnVwDj5No8Vb/KJM5r9T1nuBbV9fGFkanL9xNuY
	0uemTBv1C7n+dEVFtEYo8G/kOSZRlPpqT4d1skThlJurb/6+OCtet8u/QPJW1eQgJn6P58av
	fh4y9bsSPDNgxjlfVueiSz90puz4dP9o8YH8iVVGgbNmM4eJPlt89+wO78DMMK0UnW9aP9mE
	HiqxFGckGmoxFxUnAgCFrbopywIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes an extra line and fixes a styling nit
in exynos5_i2c_message_start()

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 drivers/i2c/busses/i2c-exynos5.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index 0d1a7bc..4c2e6f3 100644
--- a/drivers/i2c/busses/i2c-exynos5.c
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -525,7 +525,7 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
 	if (i2c->msg->flags & I2C_M_RD) {
 		i2c_ctl |= HSI2C_RXCHON;
 
-		i2c_auto_conf = HSI2C_READ_WRITE;
+		i2c_auto_conf |= HSI2C_READ_WRITE;
 
 		trig_lvl = (i2c->msg->len > i2c->variant->fifo_depth) ?
 			(i2c->variant->fifo_depth * 3 / 4) : i2c->msg->len;
@@ -548,7 +548,6 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
 	writel(fifo_ctl, i2c->regs + HSI2C_FIFO_CTL);
 	writel(i2c_ctl, i2c->regs + HSI2C_CTL);
 
-
 	/*
 	 * Enable interrupts before starting the transfer so that we don't
 	 * miss any INT_I2C interrupts.
-- 
1.7.9.5


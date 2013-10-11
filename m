Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab3JKLYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:24:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23778 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3JKLYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:24:43 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-28-5257dff99e39
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: wsa@the-dreams.de, khali@linux-fr.org, ben-linux@fluff.org,
        grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        sjg@chromium.org, naveenkrishna.ch@gmail.com,
        broonie@opensource.wolfsonmicro.com, diander@google.com,
        cpgs@samsung.com
Subject: [PATCH] i2c: s3c2410: dont need CPU_FREQ transitions for exynos series
Date: Fri, 11 Oct 2013 16:56:54 +0530
Message-id: <1381490814-20890-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWyRsSkWvfn/fAgg80LOCwmrTvAZPFv9ik2
	i5eHNC0OzH7IatHXvYbJ4tWZjWwWjX8jLTr+fmG0uLxrDpvFjPP7mCwWbfvPbPFtyzZGi5Un
	ZjE78HrMbrjI4vF31Qtmj52z7rJ7LNhU6nGl4SSbx/kZCxk9Xk78zebRt2UVo8fPlzoeJ089
	YfH4vEkugDuKyyYlNSezLLVI3y6BK6P5YwdTwWmuihVbTzI2MD7h6GLk5JAQMJFYfnwhK4Qt
	JnHh3no2EFtIYCmjRMPmyi5GDrCaWWftuxi5gMLTGSW+7dvCDuH0MEl8fbSSHaSBTcBM4uCi
	1WC2iECCROekU0wgRcwCfxkluhvngm0QFvCX2LZ7IjPIVBYBVYnrqytBwrwCrhJLf51igzhC
	UaL72QQo+xa7xO8pWSA2i4CAxLfJh1ggDpKV2HSAGaJEUuLgihssExgFFzAyrGIUTS1ILihO
	Si8y1StOzC0uzUvXS87P3cQIjJHT/55N3MF4/4D1IcZkoHETmaVEk/OBMZZXEm9obGZkYWpi
	amxkbmlGmrCSOK96i3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsaoj2teXnjRw5+oc+zn
	sl1fBdJs7q2o266b4s9WOUvs34OcGbIb+rs8kjbm8U5LjBLXL8nzSc7oWpZd1sC8+p2z/OpZ
	hdGHJ7ut43nUdqQ8Q/6B4yZLVr4jLzcmHDS4Yl2/Vez4nLRVvrHvbxzO2vnE7NGCVfX1Zdnb
	jPNPzRHUi2LZoNYR8UuJpTgj0VCLuag4EQCV/vPlpwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jQd0f98ODDHYetbGYtO4Ak8W/2afY
	LF4e0rQ4MPshq0Vf9xomi1dnNrJZNP6NtOj4+4XR4vKuOWwWM87vY7JYtO0/s8W3LdsYLVae
	mMXswOsxu+Eii8ffVS+YPXbOusvusWBTqceVhpNsHudnLGT0eDnxN5tH35ZVjB4/X+p4nDz1
	hMXj8ya5AO6oBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58A
	XbfMHKD7lRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZzR87mApOc1Ws
	2HqSsYHxCUcXIweHhICJxKyz9l2MnECmmMSFe+vZuhi5OIQEpjNKfNu3hR3C6WGS+PpoJTtI
	FZuAmcTBRavBbBGBBInOSaeYQIqYBf4ySnQ3zmUFSQgL+Ets2z2RGWQDi4CqxPXVlSBhXgFX
	iaW/TrFBbFOU6H42gW0CI/cCRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFR+ExqB+PK
	BotDjAIcjEo8vA/+hgUJsSaWFVfmHmKU4GBWEuEVPBkeJMSbklhZlVqUH19UmpNafIgxGWj5
	RGYp0eR8YILIK4k3NDYxNzU2tTSxMDGzJE1YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQbG
	Wocp3+NcrL9Pd28/IJPFamGvKxLMwugSqmUrnP0liHNjTfPDzBe2FlHLVy78VbwoQTRi6uI1
	e36t9E3z+nz5t0XT8rif5S1KYf/nVfAZnTNOdHs3k/dJ/B/xo1+0/nS8zTUMf7Dy+rIZhzNU
	IwLil789KZm8eYrUgTXlv6YF//IP7qtWPL5QiaU4I9FQi7moOBEAdHNtKAYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exynos5 i2c clock is based on a fixed 66 MHz peripheral clock, and
therefore is completely independent of the cpu frequency.
Thus, registering for a CPU freq notifier is very wasteful.

This patch modifes the code such that, i2c bus registers to
cpu_freq_transition only for non Exynos SoCs.

This change should save a bunch of cpufreq transitions calls
which does not apply to exynos SoCs.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 drivers/i2c/busses/i2c-s3c2410.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index cab1c91..d062fa7 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -123,7 +123,7 @@ struct s3c24xx_i2c {
 	struct s3c2410_platform_i2c	*pdata;
 	int			gpios[2];
 	struct pinctrl          *pctrl;
-#ifdef CONFIG_CPU_FREQ
+#if defined(CONFIG_CPU_FREQ) && !defined(CONFIG_ARCH_EXYNOS)
 	struct notifier_block	freq_transition;
 #endif
 };
@@ -843,7 +843,7 @@ static int s3c24xx_i2c_clockrate(struct s3c24xx_i2c *i2c, unsigned int *got)
 	return 0;
 }
 
-#ifdef CONFIG_CPU_FREQ
+#if defined(CONFIG_CPU_FREQ) && !defined(CONFIG_ARCH_EXYNOS)
 
 #define freq_to_i2c(_n) container_of(_n, struct s3c24xx_i2c, freq_transition)
 
-- 
1.7.9.5


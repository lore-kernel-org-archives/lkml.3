Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaHEM2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:28:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57427 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbaHEM15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:27:57 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-fb-53e0cdc75cc4
From: Chanwoo Choi <cw00.choi@samsung.com>
To: a.zummo@towertech.it
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 4/5] rtc: s3c: Add support for RTC of Exynos3250 SoC
Date: Tue, 05 Aug 2014 21:27:45 +0900
Message-id: <1407241666-17835-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1407241666-17835-1-git-send-email-cw00.choi@samsung.com>
References: <1407241666-17835-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWyRsSkQPf42QfBBgcmmFssuXiV3eL6l+es
	Fr0LrrJZnG16w25xedccNosZ5/cxWezv7GB0YPfYM/Ekm0ffllWMHtPn/WTy+LxJLoAlissm
	JTUnsyy1SN8ugSvjTddNtoLZcRUbl8xkbGB869vFyMkhIWAiMffoO3YIW0ziwr31bF2MXBxC
	AksZJe4/uccMU9Tx7SoLRGI6o0THlTeMEE4Tk8S1tavBqtgEtCT2v7jBBmKLCEhILJlzB6yI
	WWA3o8TkNS+B2jk4hAVcJH4/NQSpYRFQlTjX+poVxOYVcJU48+EvK8Q2OYkPex6BncQp4CYx
	6fE0MFsIqKZ5+x+wmRIC09klHr86wwwxSEDi2+RDYPMlBGQlNh2AulpS4uCKGywTGIUXMDKs
	YhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAgM79P/nvXuYLx9wPoQYzLQuInMUqLJ+cD4yCuJ
	NzQ2M7IwNTE1NjK3NCNNWEmcN+lhUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxrUz19n+
	SFmV5vZyq7y3zd/0/hceWhkfrxR9Y2k+99KFQ2hH8RcRNy9Nlft/vhTzbpu3pV0h9FTGP0M7
	nl0vo/4cm/wuas7qQCNZj827GyYlzDbl4tWRYmbcVtg384CaNhPrs+RPAWYbFnJOq2HJNrDT
	3FyZkL6gZ4V1pE9h1cbd7YXNW9/ZKbEUZyQaajEXFScCADbtW6WFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQd3jZx8EGyxepW+x5OJVdovrX56z
	WvQuuMpmcbbpDbvF5V1z2CxmnN/HZLG/s4PRgd1jz8STbB59W1Yxekyf95PJ4/MmuQCWqAZG
	m4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygE5QUyhJz
	SoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGW+6brIVzI6r2LhkJmMD41vfLkZO
	DgkBE4mOb1dZIGwxiQv31rN1MXJxCAlMZ5TouPKGEcJpYpK4tnY1M0gVm4CWxP4XN9hAbBEB
	CYklc+6AFTEL7GaUmLzmJdAoDg5hAReJ308NQWpYBFQlzrW+ZgWxeQVcJc58+MsKsU1O4sOe
	R+wgNqeAm8Skx9PAbCGgmubtfxgnMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc
	Pc+kdjCubLA4xCjAwajEwyugdj9YiDWxrLgy9xCjBAezkgjv010PgoV4UxIrq1KL8uOLSnNS
	iw8xmgJdNZFZSjQ5HxjZeSXxhsYmZkaWRuaGFkbG5krivAdarQOFBNITS1KzU1MLUotg+pg4
	OKUaGI04JiZsVJ/Joyl7xCjqxcYZc2fO5nm12Ntg0XO2+LXH90/qPnJq/cSglrXdW+uNgzJu
	2JQebtkS7irzwa53kXMAa0PrwceLbnBc2+Egm/hbw2OzfZPQo1k3BX8erAqYki3rs/Duid1R
	Vi4rJoucOM/1/IPJLYGbjZcX5n2I3Jtqczj/6NHY/qdKLMUZiYZazEXFiQAOQ+4YtAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support for RTC of Exynos3250 SoC. The Exynos3250 needs source
clock(32.768KHz) for RTC block. If source clock of RTC is registerd on clock
list of common clk framework, Exynos RTC drvier have to control this clock.

Clock list for s3c-rtc device:
- rtc : CLK_RTC of CLK_GATE_IP_PERIR is gate clock for RTC.
- rtc_src : XrtcXTI is 32.768.kHz source clock for RTC.
 (XRTCXTI: Specifies a clock from 32.768 kHz crystal pad with XRTCXTI and
 XRTCXTO pins. RTC uses this clock as the source of a real-time clock.)

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/devicetree/bindings/rtc/s3c-rtc.txt |  1 +
 drivers/rtc/rtc-s3c.c                             | 93 ++++++++++++++++++++++-
 2 files changed, 93 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/rtc/s3c-rtc.txt b/Documentation/devicetree/bindings/rtc/s3c-rtc.txt
index 06db446..ab757b84 100644
--- a/Documentation/devicetree/bindings/rtc/s3c-rtc.txt
+++ b/Documentation/devicetree/bindings/rtc/s3c-rtc.txt
@@ -6,6 +6,7 @@ Required properties:
     * "samsung,s3c2416-rtc" - for controllers compatible with s3c2416 rtc.
     * "samsung,s3c2443-rtc" - for controllers compatible with s3c2443 rtc.
     * "samsung,s3c6410-rtc" - for controllers compatible with s3c6410 rtc.
+    * "samsung,exynos3250-rtc" - for controllers compatible with exynos3250 rtc.
 - reg: physical base address of the controller and length of memory mapped
   region.
 - interrupts: Two interrupt numbers to the cpu should be specified. First
diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 43070f5..e0719a7 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -38,6 +38,7 @@ struct s3c_rtc {
 
 	void __iomem *base;
 	struct clk *rtc_clk;
+	struct clk *rtc_src_clk;
 	bool enabled;
 
 	struct s3c_rtc_data *data;
@@ -54,6 +55,7 @@ struct s3c_rtc {
 
 struct s3c_rtc_data {
 	int max_user_freq;
+	bool needs_src_clk;
 
 	void (*irq_handler) (struct s3c_rtc *info, int mask);
 	void (*set_freq) (struct s3c_rtc *info, int freq);
@@ -73,10 +75,14 @@ static void s3c_rtc_alarm_clk_enable(struct s3c_rtc *info, bool enable)
 	if (enable) {
 		if (!info->enabled) {
 			clk_enable(info->rtc_clk);
+			if (info->data->needs_src_clk)
+				clk_enable(info->rtc_src_clk);
 			info->enabled = true;
 		}
 	} else {
 		if (info->enabled) {
+			if (info->data->needs_src_clk)
+				clk_disable(info->rtc_src_clk);
 			clk_disable(info->rtc_clk);
 			info->enabled = false;
 		}
@@ -114,12 +120,16 @@ static int s3c_rtc_setaie(struct device *dev, unsigned int enabled)
 	dev_dbg(info->dev, "%s: aie=%d\n", __func__, enabled);
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 	tmp = readb(info->base + S3C2410_RTCALM) & ~S3C2410_RTCALM_ALMEN;
 
 	if (enabled)
 		tmp |= S3C2410_RTCALM_ALMEN;
 
 	writeb(tmp, info->base + S3C2410_RTCALM);
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	s3c_rtc_alarm_clk_enable(info, enabled);
@@ -134,12 +144,16 @@ static int s3c_rtc_setfreq(struct s3c_rtc *info, int freq)
 		return -EINVAL;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 	spin_lock_irq(&info->pie_lock);
 
 	if (info->data->set_freq)
 		info->data->set_freq(info, freq);
 
 	spin_unlock_irq(&info->pie_lock);
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -152,6 +166,9 @@ static int s3c_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 	unsigned int have_retried = 0;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
+
  retry_get_time:
 	rtc_tm->tm_min  = readb(info->base + S3C2410_RTCMIN);
 	rtc_tm->tm_hour = readb(info->base + S3C2410_RTCHOUR);
@@ -185,6 +202,8 @@ static int s3c_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 
 	rtc_tm->tm_mon -= 1;
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return rtc_valid_tm(rtc_tm);
@@ -207,6 +226,8 @@ static int s3c_rtc_settime(struct device *dev, struct rtc_time *tm)
 	}
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	writeb(bin2bcd(tm->tm_sec),  info->base + S3C2410_RTCSEC);
 	writeb(bin2bcd(tm->tm_min),  info->base + S3C2410_RTCMIN);
@@ -215,6 +236,8 @@ static int s3c_rtc_settime(struct device *dev, struct rtc_time *tm)
 	writeb(bin2bcd(tm->tm_mon + 1), info->base + S3C2410_RTCMON);
 	writeb(bin2bcd(year), info->base + S3C2410_RTCYEAR);
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -227,6 +250,9 @@ static int s3c_rtc_getalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	unsigned int alm_en;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
+
 	alm_tm->tm_sec  = readb(info->base + S3C2410_ALMSEC);
 	alm_tm->tm_min  = readb(info->base + S3C2410_ALMMIN);
 	alm_tm->tm_hour = readb(info->base + S3C2410_ALMHOUR);
@@ -278,7 +304,10 @@ static int s3c_rtc_getalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	else
 		alm_tm->tm_year = -1;
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
+
 	return 0;
 }
 
@@ -289,6 +318,9 @@ static int s3c_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	unsigned int alrm_en;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
+
 	dev_dbg(dev, "s3c_rtc_setalarm: %d, %04d.%02d.%02d %02d:%02d:%02d\n",
 		 alrm->enabled,
 		 1900 + tm->tm_year, tm->tm_mon + 1, tm->tm_mday,
@@ -318,6 +350,8 @@ static int s3c_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	s3c_rtc_setaie(dev, alrm->enabled);
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -328,10 +362,14 @@ static int s3c_rtc_proc(struct device *dev, struct seq_file *seq)
 	struct s3c_rtc *info = dev_get_drvdata(dev);
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	if (info->data->enable_tick)
 		info->data->enable_tick(info, seq);
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -351,6 +389,8 @@ static void s3c24xx_rtc_enable(struct s3c_rtc *info)
 	unsigned int con, tmp;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	con = readw(info->base + S3C2410_RTCCON);
 	/* re-enable the device, and check it is ok */
@@ -378,6 +418,8 @@ static void s3c24xx_rtc_enable(struct s3c_rtc *info)
 			info->base + S3C2410_RTCCON);
 	}
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 }
 
@@ -386,6 +428,8 @@ static void s3c24xx_rtc_disable(struct s3c_rtc *info)
 	unsigned int con;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	con = readw(info->base + S3C2410_RTCCON);
 	con &= ~S3C2410_RTCCON_RTCEN;
@@ -395,6 +439,8 @@ static void s3c24xx_rtc_disable(struct s3c_rtc *info)
 	con &= ~S3C2410_TICNT_ENABLE;
 	writeb(con, info->base + S3C2410_TICNT);
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 }
 
@@ -403,12 +449,16 @@ static void s3c6410_rtc_disable(struct s3c_rtc *info)
 	unsigned int con;
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	con = readw(info->base + S3C2410_RTCCON);
 	con &= ~S3C64XX_RTCCON_TICEN;
 	con &= ~S3C2410_RTCCON_RTCEN;
 	writew(con, info->base + S3C2410_RTCCON);
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 }
 
@@ -480,11 +530,19 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 
 	info->rtc_clk = devm_clk_get(&pdev->dev, "rtc");
 	if (IS_ERR(info->rtc_clk)) {
-		dev_err(&pdev->dev, "failed to find rtc clock source\n");
+		dev_err(&pdev->dev, "failed to find rtc clock\n");
 		return PTR_ERR(info->rtc_clk);
 	}
 	clk_prepare_enable(info->rtc_clk);
 
+	info->rtc_src_clk = devm_clk_get(&pdev->dev, "rtc_src");
+	if (IS_ERR(info->rtc_src_clk)) {
+		dev_err(&pdev->dev, "failed to find rtc source clock\n");
+		return PTR_ERR(info->rtc_src_clk);
+	}
+	clk_prepare_enable(info->rtc_src_clk);
+
+
 	/* check to see if everything is setup correctly */
 	if (info->data->enable)
 		info->data->enable(info);
@@ -538,6 +596,8 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 
 	s3c_rtc_setfreq(info, 1);
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -557,6 +617,8 @@ static int s3c_rtc_suspend(struct device *dev)
 	struct s3c_rtc *info = dev_get_drvdata(dev);
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	/* save TICNT for anyone using periodic interrupts */
 	if (info->data->save_tick_cnt)
@@ -572,6 +634,8 @@ static int s3c_rtc_suspend(struct device *dev)
 			dev_err(dev, "enable_irq_wake failed\n");
 	}
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -582,6 +646,8 @@ static int s3c_rtc_resume(struct device *dev)
 	struct s3c_rtc *info = dev_get_drvdata(dev);
 
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 
 	if (info->data->enable)
 		info->data->enable(info);
@@ -594,6 +660,8 @@ static int s3c_rtc_resume(struct device *dev)
 		info->wake_en = false;
 	}
 
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -604,7 +672,11 @@ static SIMPLE_DEV_PM_OPS(s3c_rtc_pm_ops, s3c_rtc_suspend, s3c_rtc_resume);
 static void s3c24xx_rtc_irq(struct s3c_rtc *info, int mask)
 {
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 	rtc_update_irq(info->rtc, 1, RTC_AF | RTC_IRQF);
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	s3c_rtc_alarm_clk_enable(info, false);
@@ -613,8 +685,12 @@ static void s3c24xx_rtc_irq(struct s3c_rtc *info, int mask)
 static void s3c6410_rtc_irq(struct s3c_rtc *info, int mask)
 {
 	clk_enable(info->rtc_clk);
+	if (info->data->needs_src_clk)
+		clk_enable(info->rtc_src_clk);
 	rtc_update_irq(info->rtc, 1, RTC_AF | RTC_IRQF);
 	writeb(mask, info->base + S3C2410_INTP);
+	if (info->data->needs_src_clk)
+		clk_disable(info->rtc_src_clk);
 	clk_disable(info->rtc_clk);
 
 	s3c_rtc_alarm_clk_enable(info, false);
@@ -780,6 +856,18 @@ static struct s3c_rtc_data const s3c6410_rtc_data = {
 	.disable		= s3c6410_rtc_disable,
 };
 
+static struct s3c_rtc_data const exynos3250_rtc_data = {
+	.max_user_freq		= 32768,
+	.needs_src_clk		= true,
+	.irq_handler		= s3c6410_rtc_irq,
+	.set_freq		= s3c6410_rtc_setfreq,
+	.enable_tick		= s3c6410_rtc_enable_tick,
+	.save_tick_cnt		= s3c6410_rtc_save_tick_cnt,
+	.restore_tick_cnt	= s3c6410_rtc_restore_tick_cnt,
+	.enable			= s3c24xx_rtc_enable,
+	.disable		= s3c6410_rtc_disable,
+};
+
 static const struct of_device_id s3c_rtc_dt_match[] = {
 	{
 		.compatible = "samsung,s3c2410-rtc",
@@ -793,6 +881,9 @@ static const struct of_device_id s3c_rtc_dt_match[] = {
 	}, {
 		.compatible = "samsung,s3c6410-rtc",
 		.data = (void *)&s3c6410_rtc_data,
+	}, {
+		.compatible = "samsung,exynos3250-rtc",
+		.data = (void *)&exynos3250_rtc_data,
 	},
 	{ /* sentinel */ },
 };
-- 
1.8.0


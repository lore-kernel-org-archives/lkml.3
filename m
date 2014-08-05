Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbaHEM2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:28:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34068 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbaHEM1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:27:53 -0400
X-AuditID: cbfee691-b7f306d000003d81-e1-53e0cdc768d0
From: Chanwoo Choi <cw00.choi@samsung.com>
To: a.zummo@towertech.it
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 3/5] rtc: s3c: Add s3c_rtc_data structure to use variant data
 instead of s3c_cpu_type
Date: Tue, 05 Aug 2014 21:27:44 +0900
Message-id: <1407241666-17835-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1407241666-17835-1-git-send-email-cw00.choi@samsung.com>
References: <1407241666-17835-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsWyRsSkQPf42QfBBk/WClssuXiV3eL6l+es
	Fr0LrrJZnG16w25xedccNosZ5/cxWezv7GB0YPfYM/Ekm0ffllWMHtPn/WTy+LxJLoAlissm
	JTUnsyy1SN8ugSvj0cUOxoKu6YwV6w5+YG5gnF/TxcjJISFgIrG9/zgLhC0mceHeerYuRi4O
	IYGljBKnb65ihSma1bSNHSIxnVHi+sl9LBBOE5PEtbWrmUGq2AS0JPa/uMEGYosISEgsmXOH
	EaSIWWA3o8TkNS/BdggLpEtc/vEJrIhFQFXi5g2QsZwcvAKuEsv2vWOHWCcn8WHPIzCbU8BN
	YtLjaWC2EFBN8/Y/YEMlBPrZJR49Ogo1SEDi2+RDQAs4gBKyEpsOMEPMkZQ4uOIGywRG4QWM
	DKsYRVMLkguKk9KLTPWKE3OLS/PS9ZLzczcxAkP89L9nE3cw3j9gfYgxGWjcRGYp0eR8YIzk
	lcQbGpsZWZiamBobmVuakSasJM6b/igpSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjmpeb
	zXw5xfoZQpkPJ5xPUuhUXsJ7evHSRsEN7w7kipmwP73QsUmpg9fN54JcSfieQP/4rXdknOwc
	983ZN+OuZ8yZSokXa2oVLBbKWReePHhd4OSdxD1TL6vldZ5mY5xUxORV4OL8ofG6WkL73cBp
	wlP+5Z6KZnoWlHiCdc36YtM539y/HX2vxFKckWioxVxUnAgAFBlMFocCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t9jQd3jZx8EG7x4wWWx5OJVdovrX56z
	WvQuuMpmcbbpDbvF5V1z2CxmnN/HZLG/s4PRgd1jz8STbB59W1Yxekyf95PJ4/MmuQCWqAZG
	m4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygE5QUyhJz
	SoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGY8udjAWdE1nrFh38ANzA+P8mi5G
	Tg4JAROJWU3b2CFsMYkL99azdTFycQgJTGeUuH5yHwuE08QkcW3tamaQKjYBLYn9L26wgdgi
	AhISS+bcYQQpYhbYzSgxec1LFpCEsEC6xOUfn8CKWARUJW7egFjBK+AqsWzfO6h1chIf9jwC
	szkF3CQmPZ4GZgsB1TRv/8M4gZF3ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgCHom
	tYNxZYPFIUYBDkYlHl4BtfvBQqyJZcWVuYcYJTiYlUR4n+56ECzEm5JYWZValB9fVJqTWnyI
	0RToqonMUqLJ+cDoziuJNzQ2MTOyNDI3tDAyNlcS5z3Qah0oJJCeWJKanZpakFoE08fEwSnV
	wHjUtv9X8x0Hjpy7mXktvCKazbVZ7CaPevr+9V3y+rzi6nbbJXaVfoLTlHMUTFS4Kp6vTPBK
	azu7KrLn7RlXL/Ukga2i2hyV+9Uf2WuLhu3yXWN9J+FDu99iWZnDida3tL7WPbbolq1mWsQe
	dPfAR7b/Ye15uR89knvNEye4ylZlKbN//rVeiaU4I9FQi7moOBEAT+POC7YCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add s3c_rtc_data structure to variant data according to SoC type.
The s3c_rtc_data structure includes some functions to control RTC operation
and specific data dependent on SoC type.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/rtc/rtc-s3c.c | 464 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 289 insertions(+), 175 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 814ee74..43070f5 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -32,17 +32,6 @@
 #include <asm/irq.h>
 #include "rtc-s3c.h"
 
-enum s3c_cpu_type {
-	TYPE_S3C2410,
-	TYPE_S3C2416,
-	TYPE_S3C2443,
-	TYPE_S3C64XX,
-};
-
-struct s3c_rtc_drv_data {
-	int cpu_type;
-};
-
 struct s3c_rtc {
 	struct device *dev;
 	struct rtc_device *rtc;
@@ -51,7 +40,7 @@ struct s3c_rtc {
 	struct clk *rtc_clk;
 	bool enabled;
 
-	enum s3c_cpu_type cpu_type;
+	struct s3c_rtc_data *data;
 
 	int irq_alarm;
 	int irq_tick;
@@ -63,6 +52,19 @@ struct s3c_rtc {
 	bool wake_en;
 };
 
+struct s3c_rtc_data {
+	int max_user_freq;
+
+	void (*irq_handler) (struct s3c_rtc *info, int mask);
+	void (*set_freq) (struct s3c_rtc *info, int freq);
+	void (*enable_tick) (struct s3c_rtc *info, struct seq_file *seq);
+	void (*select_tick_clk) (struct s3c_rtc *info);
+	void (*save_tick_cnt) (struct s3c_rtc *info);
+	void (*restore_tick_cnt) (struct s3c_rtc *info);
+	void (*enable) (struct s3c_rtc *info);
+	void (*disable) (struct s3c_rtc *info);
+};
+
 static void s3c_rtc_alarm_clk_enable(struct s3c_rtc *info, bool enable)
 {
 	unsigned long irq_flags;
@@ -83,34 +85,22 @@ static void s3c_rtc_alarm_clk_enable(struct s3c_rtc *info, bool enable)
 }
 
 /* IRQ Handlers */
-static irqreturn_t s3c_rtc_alarmirq(int irq, void *id)
+static irqreturn_t s3c_rtc_tickirq(int irq, void *id)
 {
 	struct s3c_rtc *info = (struct s3c_rtc *)id;
 
-	clk_enable(info->rtc_clk);
-	rtc_update_irq(info->rtc, 1, RTC_AF | RTC_IRQF);
-
-	if (info->cpu_type == TYPE_S3C64XX)
-		writeb(S3C2410_INTP_ALM, info->base + S3C2410_INTP);
-
-	clk_disable(info->rtc_clk);
-
-	s3c_rtc_alarm_clk_enable(info, false);
+	if (info->data->irq_handler)
+		info->data->irq_handler(info, S3C2410_INTP_TIC);
 
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t s3c_rtc_tickirq(int irq, void *id)
+static irqreturn_t s3c_rtc_alarmirq(int irq, void *id)
 {
 	struct s3c_rtc *info = (struct s3c_rtc *)id;
 
-	clk_enable(info->rtc_clk);
-	rtc_update_irq(info->rtc, 1, RTC_PF | RTC_IRQF);
-
-	if (info->cpu_type == TYPE_S3C64XX)
-		writeb(S3C2410_INTP_TIC, info->base + S3C2410_INTP);
-
-	clk_disable(info->rtc_clk);
+	if (info->data->irq_handler)
+		info->data->irq_handler(info, S3C2410_INTP_ALM);
 
 	return IRQ_HANDLED;
 }
@@ -137,36 +127,18 @@ static int s3c_rtc_setaie(struct device *dev, unsigned int enabled)
 	return 0;
 }
 
+/* Set RTC frequency */
 static int s3c_rtc_setfreq(struct s3c_rtc *info, int freq)
 {
-	unsigned int tmp = 0;
-	int val;
-
 	if (!is_power_of_2(freq))
 		return -EINVAL;
 
 	clk_enable(info->rtc_clk);
 	spin_lock_irq(&info->pie_lock);
 
-	if (info->cpu_type != TYPE_S3C64XX) {
-		tmp = readb(info->base + S3C2410_TICNT);
-		tmp &= S3C2410_TICNT_ENABLE;
-	}
-
-	val = (info->rtc->max_user_freq / freq) - 1;
-
-	if (info->cpu_type == TYPE_S3C2416 || info->cpu_type == TYPE_S3C2443) {
-		tmp |= S3C2443_TICNT_PART(val);
-		writel(S3C2443_TICNT1_PART(val), info->base + S3C2443_TICNT1);
+	if (info->data->set_freq)
+		info->data->set_freq(info, freq);
 
-		if (info->cpu_type == TYPE_S3C2416)
-			writel(S3C2416_TICNT2_PART(val),
-				info->base + S3C2416_TICNT2);
-	} else {
-		tmp |= val;
-	}
-
-	writel(tmp, info->base + S3C2410_TICNT);
 	spin_unlock_irq(&info->pie_lock);
 	clk_disable(info->rtc_clk);
 
@@ -174,7 +146,6 @@ static int s3c_rtc_setfreq(struct s3c_rtc *info, int freq)
 }
 
 /* Time read/write */
-
 static int s3c_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 {
 	struct s3c_rtc *info = dev_get_drvdata(dev);
@@ -355,19 +326,14 @@ static int s3c_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 static int s3c_rtc_proc(struct device *dev, struct seq_file *seq)
 {
 	struct s3c_rtc *info = dev_get_drvdata(dev);
-	unsigned int ticnt;
 
 	clk_enable(info->rtc_clk);
-	if (info->cpu_type == TYPE_S3C64XX) {
-		ticnt = readw(info->base + S3C2410_RTCCON);
-		ticnt &= S3C64XX_RTCCON_TICEN;
-	} else {
-		ticnt = readb(info->base + S3C2410_TICNT);
-		ticnt &= S3C2410_TICNT_ENABLE;
-	}
 
-	seq_printf(seq, "periodic_IRQ\t: %s\n", ticnt  ? "yes" : "no");
+	if (info->data->enable_tick)
+		info->data->enable_tick(info, seq);
+
 	clk_disable(info->rtc_clk);
+
 	return 0;
 }
 
@@ -380,53 +346,69 @@ static const struct rtc_class_ops s3c_rtcops = {
 	.alarm_irq_enable = s3c_rtc_setaie,
 };
 
-static void s3c_rtc_enable(struct s3c_rtc *info, int en)
+static void s3c24xx_rtc_enable(struct s3c_rtc *info)
 {
 	unsigned int con, tmp;
 
-	if (!info->base)
-		return;
-
 	clk_enable(info->rtc_clk);
 
 	con = readw(info->base + S3C2410_RTCCON);
-	if (!en) {
-		if (info->cpu_type == TYPE_S3C64XX)
-			con &= ~S3C64XX_RTCCON_TICEN;
-		con &= ~S3C2410_RTCCON_RTCEN;
-		writew(con, info->base + S3C2410_RTCCON);
-
-		if (info->cpu_type != TYPE_S3C64XX) {
-			con = readb(info->base + S3C2410_TICNT);
-			con &= ~S3C2410_TICNT_ENABLE;
-			writeb(con, info->base + S3C2410_TICNT);
-		}
-	} else {
-		/* re-enable the device, and check it is ok */
-		if ((con & S3C2410_RTCCON_RTCEN) == 0) {
-			dev_info(info->dev, "rtc disabled, re-enabling\n");
+	/* re-enable the device, and check it is ok */
+	if ((con & S3C2410_RTCCON_RTCEN) == 0) {
+		dev_info(info->dev, "rtc disabled, re-enabling\n");
 
-			tmp = readw(info->base + S3C2410_RTCCON);
-			writew(tmp | S3C2410_RTCCON_RTCEN,
-				info->base + S3C2410_RTCCON);
-		}
+		tmp = readw(info->base + S3C2410_RTCCON);
+		writew(tmp | S3C2410_RTCCON_RTCEN,
+			info->base + S3C2410_RTCCON);
+	}
 
-		if (con & S3C2410_RTCCON_CNTSEL) {
-			dev_info(info->dev, "removing RTCCON_CNTSEL\n");
+	if (con & S3C2410_RTCCON_CNTSEL) {
+		dev_info(info->dev, "removing RTCCON_CNTSEL\n");
 
-			tmp = readw(info->base + S3C2410_RTCCON);
-			writew(tmp & ~S3C2410_RTCCON_CNTSEL,
-				info->base + S3C2410_RTCCON);
-		}
+		tmp = readw(info->base + S3C2410_RTCCON);
+		writew(tmp & ~S3C2410_RTCCON_CNTSEL,
+			info->base + S3C2410_RTCCON);
+	}
 
-		if (con & S3C2410_RTCCON_CLKRST) {
-			dev_info(info->dev, "removing RTCCON_CLKRST\n");
+	if (con & S3C2410_RTCCON_CLKRST) {
+		dev_info(info->dev, "removing RTCCON_CLKRST\n");
 
-			tmp = readw(info->base + S3C2410_RTCCON);
-			writew(tmp & ~S3C2410_RTCCON_CLKRST,
-				info->base + S3C2410_RTCCON);
-		}
+		tmp = readw(info->base + S3C2410_RTCCON);
+		writew(tmp & ~S3C2410_RTCCON_CLKRST,
+			info->base + S3C2410_RTCCON);
 	}
+
+	clk_disable(info->rtc_clk);
+}
+
+static void s3c24xx_rtc_disable(struct s3c_rtc *info)
+{
+	unsigned int con;
+
+	clk_enable(info->rtc_clk);
+
+	con = readw(info->base + S3C2410_RTCCON);
+	con &= ~S3C2410_RTCCON_RTCEN;
+	writew(con, info->base + S3C2410_RTCCON);
+
+	con = readb(info->base + S3C2410_TICNT);
+	con &= ~S3C2410_TICNT_ENABLE;
+	writeb(con, info->base + S3C2410_TICNT);
+
+	clk_disable(info->rtc_clk);
+}
+
+static void s3c6410_rtc_disable(struct s3c_rtc *info)
+{
+	unsigned int con;
+
+	clk_enable(info->rtc_clk);
+
+	con = readw(info->base + S3C2410_RTCCON);
+	con &= ~S3C64XX_RTCCON_TICEN;
+	con &= ~S3C2410_RTCCON_RTCEN;
+	writew(con, info->base + S3C2410_RTCCON);
+
 	clk_disable(info->rtc_clk);
 }
 
@@ -444,20 +426,12 @@ static int s3c_rtc_remove(struct platform_device *pdev)
 
 static const struct of_device_id s3c_rtc_dt_match[];
 
-static inline int s3c_rtc_get_driver_data(struct platform_device *pdev)
+static struct s3c_rtc_data *s3c_rtc_get_data(struct platform_device *pdev)
 {
-#ifdef CONFIG_OF
-	struct s3c_rtc_drv_data *data;
-
-	if (pdev->dev.of_node) {
-		const struct of_device_id *match;
+	const struct of_device_id *match;
 
-		match = of_match_node(s3c_rtc_dt_match, pdev->dev.of_node);
-		data = (struct s3c_rtc_drv_data *) match->data;
-		return data->cpu_type;
-	}
-#endif
-	return platform_get_device_id(pdev)->driver_data;
+	match = of_match_node(s3c_rtc_dt_match, pdev->dev.of_node);
+	return (struct s3c_rtc_data *)match->data;
 }
 
 static int s3c_rtc_probe(struct platform_device *pdev)
@@ -466,7 +440,6 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 	struct rtc_time rtc_tm;
 	struct resource *res;
 	int ret;
-	int tmp;
 
 	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
 	if (!info)
@@ -480,7 +453,11 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 	}
 
 	info->dev = &pdev->dev;
-	info->cpu_type = s3c_rtc_get_driver_data(pdev);
+	info->data = s3c_rtc_get_data(pdev);
+	if (!info->data) {
+		dev_err(&pdev->dev, "failed getting s3c_rtc_data\n");
+		return -EINVAL;
+	}
 	spin_lock_init(&info->pie_lock);
 	spin_lock_init(&info->alarm_clk_lock);
 
@@ -509,7 +486,8 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 	clk_prepare_enable(info->rtc_clk);
 
 	/* check to see if everything is setup correctly */
-	s3c_rtc_enable(info, 1);
+	if (info->data->enable)
+		info->data->enable(info);
 
 	dev_dbg(&pdev->dev, "s3c2410_rtc: RTCCON=%02x\n",
 		 readw(info->base + S3C2410_RTCCON));
@@ -555,16 +533,8 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev, "warning: invalid RTC value so initializing it\n");
 	}
 
-	if (info->cpu_type != TYPE_S3C2410)
-		info->rtc->max_user_freq = 32768;
-	else
-		info->rtc->max_user_freq = 128;
-
-	if (info->cpu_type == TYPE_S3C2416 || info->cpu_type == TYPE_S3C2443) {
-		tmp = readw(info->base + S3C2410_RTCCON);
-		tmp |= S3C2443_RTCCON_TICSEL;
-		writew(tmp, info->base + S3C2410_RTCCON);
-	}
+	if (info->data->select_tick_clk)
+		info->data->select_tick_clk(info);
 
 	s3c_rtc_setfreq(info, 1);
 
@@ -573,7 +543,8 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 	return 0;
 
  err_nortc:
-	s3c_rtc_enable(info, 0);
+	if (info->data->disable)
+		info->data->disable(info);
 	clk_disable_unprepare(info->rtc_clk);
 
 	return ret;
@@ -586,15 +557,13 @@ static int s3c_rtc_suspend(struct device *dev)
 	struct s3c_rtc *info = dev_get_drvdata(dev);
 
 	clk_enable(info->rtc_clk);
+
 	/* save TICNT for anyone using periodic interrupts */
-	if (info->cpu_type == TYPE_S3C64XX) {
-		info->ticnt_en_save = readw(info->base + S3C2410_RTCCON);
-		info->ticnt_en_save &= S3C64XX_RTCCON_TICEN;
-		info->ticnt_save = readl(info->base + S3C2410_TICNT);
-	} else {
-		info->ticnt_save = readb(info->base + S3C2410_TICNT);
-	}
-	s3c_rtc_enable(info, 0);
+	if (info->data->save_tick_cnt)
+		info->data->save_tick_cnt(info);
+
+	if (info->data->disable)
+		info->data->disable(info);
 
 	if (device_may_wakeup(dev) && !info->wake_en) {
 		if (enable_irq_wake(info->irq_alarm) == 0)
@@ -602,6 +571,7 @@ static int s3c_rtc_suspend(struct device *dev)
 		else
 			dev_err(dev, "enable_irq_wake failed\n");
 	}
+
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -610,25 +580,20 @@ static int s3c_rtc_suspend(struct device *dev)
 static int s3c_rtc_resume(struct device *dev)
 {
 	struct s3c_rtc *info = dev_get_drvdata(dev);
-	unsigned int tmp;
 
 	clk_enable(info->rtc_clk);
-	s3c_rtc_enable(info, 1);
-	if (info->cpu_type == TYPE_S3C64XX) {
-		writel(info->ticnt_save, info->base + S3C2410_TICNT);
-		if (info->ticnt_en_save) {
-			tmp = readw(info->base + S3C2410_RTCCON);
-			writew(tmp | info->ticnt_en_save,
-					info->base + S3C2410_RTCCON);
-		}
-	} else {
-		writeb(info->ticnt_save, info->base + S3C2410_TICNT);
-	}
+
+	if (info->data->enable)
+		info->data->enable(info);
+
+	if (info->data->restore_tick_cnt)
+		info->data->restore_tick_cnt(info);
 
 	if (device_may_wakeup(dev) && info->wake_en) {
 		disable_irq_wake(info->irq_alarm);
 		info->wake_en = false;
 	}
+
 	clk_disable(info->rtc_clk);
 
 	return 0;
@@ -636,56 +601,206 @@ static int s3c_rtc_resume(struct device *dev)
 #endif
 static SIMPLE_DEV_PM_OPS(s3c_rtc_pm_ops, s3c_rtc_suspend, s3c_rtc_resume);
 
-#ifdef CONFIG_OF
-static struct s3c_rtc_drv_data s3c_rtc_drv_data_array[] = {
-	[TYPE_S3C2410] = { TYPE_S3C2410 },
-	[TYPE_S3C2416] = { TYPE_S3C2416 },
-	[TYPE_S3C2443] = { TYPE_S3C2443 },
-	[TYPE_S3C64XX] = { TYPE_S3C64XX },
+static void s3c24xx_rtc_irq(struct s3c_rtc *info, int mask)
+{
+	clk_enable(info->rtc_clk);
+	rtc_update_irq(info->rtc, 1, RTC_AF | RTC_IRQF);
+	clk_disable(info->rtc_clk);
+
+	s3c_rtc_alarm_clk_enable(info, false);
+}
+
+static void s3c6410_rtc_irq(struct s3c_rtc *info, int mask)
+{
+	clk_enable(info->rtc_clk);
+	rtc_update_irq(info->rtc, 1, RTC_AF | RTC_IRQF);
+	writeb(mask, info->base + S3C2410_INTP);
+	clk_disable(info->rtc_clk);
+
+	s3c_rtc_alarm_clk_enable(info, false);
+}
+
+static void s3c2410_rtc_setfreq(struct s3c_rtc *info, int freq)
+{
+	unsigned int tmp = 0;
+	int val;
+
+	tmp = readb(info->base + S3C2410_TICNT);
+	tmp &= S3C2410_TICNT_ENABLE;
+
+	val = (info->rtc->max_user_freq / freq) - 1;
+	tmp |= val;
+
+	writel(tmp, info->base + S3C2410_TICNT);
+}
+
+static void s3c2416_rtc_setfreq(struct s3c_rtc *info, int freq)
+{
+	unsigned int tmp = 0;
+	int val;
+
+	tmp = readb(info->base + S3C2410_TICNT);
+	tmp &= S3C2410_TICNT_ENABLE;
+
+	val = (info->rtc->max_user_freq / freq) - 1;
+
+	tmp |= S3C2443_TICNT_PART(val);
+	writel(S3C2443_TICNT1_PART(val), info->base + S3C2443_TICNT1);
+
+	writel(S3C2416_TICNT2_PART(val), info->base + S3C2416_TICNT2);
+
+	writel(tmp, info->base + S3C2410_TICNT);
+}
+
+static void s3c2443_rtc_setfreq(struct s3c_rtc *info, int freq)
+{
+	unsigned int tmp = 0;
+	int val;
+
+	tmp = readb(info->base + S3C2410_TICNT);
+	tmp &= S3C2410_TICNT_ENABLE;
+
+	val = (info->rtc->max_user_freq / freq) - 1;
+
+	tmp |= S3C2443_TICNT_PART(val);
+	writel(S3C2443_TICNT1_PART(val), info->base + S3C2443_TICNT1);
+
+	writel(tmp, info->base + S3C2410_TICNT);
+}
+
+static void s3c6410_rtc_setfreq(struct s3c_rtc *info, int freq)
+{
+	int val;
+
+	val = (info->rtc->max_user_freq / freq) - 1;
+	writel(val, info->base + S3C2410_TICNT);
+}
+
+static void s3c24xx_rtc_enable_tick(struct s3c_rtc *info, struct seq_file *seq)
+{
+	unsigned int ticnt;
+
+	ticnt = readb(info->base + S3C2410_TICNT);
+	ticnt &= S3C2410_TICNT_ENABLE;
+
+	seq_printf(seq, "periodic_IRQ\t: %s\n", ticnt  ? "yes" : "no");
+}
+
+static void s3c2416_rtc_select_tick_clk(struct s3c_rtc *info)
+{
+	unsigned int con;
+
+	con = readw(info->base + S3C2410_RTCCON);
+	con |= S3C2443_RTCCON_TICSEL;
+	writew(con, info->base + S3C2410_RTCCON);
+}
+
+static void s3c6410_rtc_enable_tick(struct s3c_rtc *info, struct seq_file *seq)
+{
+	unsigned int ticnt;
+
+	ticnt = readw(info->base + S3C2410_RTCCON);
+	ticnt &= S3C64XX_RTCCON_TICEN;
+
+	seq_printf(seq, "periodic_IRQ\t: %s\n", ticnt  ? "yes" : "no");
+}
+
+static void s3c24xx_rtc_save_tick_cnt(struct s3c_rtc *info)
+{
+	info->ticnt_save = readb(info->base + S3C2410_TICNT);
+}
+
+static void s3c24xx_rtc_restore_tick_cnt(struct s3c_rtc *info)
+{
+	writeb(info->ticnt_save, info->base + S3C2410_TICNT);
+}
+
+static void s3c6410_rtc_save_tick_cnt(struct s3c_rtc *info)
+{
+	info->ticnt_en_save = readw(info->base + S3C2410_RTCCON);
+	info->ticnt_en_save &= S3C64XX_RTCCON_TICEN;
+	info->ticnt_save = readl(info->base + S3C2410_TICNT);
+}
+
+static void s3c6410_rtc_restore_tick_cnt(struct s3c_rtc *info)
+{
+	unsigned int con;
+
+	writel(info->ticnt_save, info->base + S3C2410_TICNT);
+	if (info->ticnt_en_save) {
+		con = readw(info->base + S3C2410_RTCCON);
+		writew(con | info->ticnt_en_save,
+				info->base + S3C2410_RTCCON);
+	}
+}
+
+static struct s3c_rtc_data const s3c2410_rtc_data = {
+	.max_user_freq		= 128,
+	.irq_handler		= s3c24xx_rtc_irq,
+	.set_freq		= s3c2410_rtc_setfreq,
+	.enable_tick		= s3c24xx_rtc_enable_tick,
+	.save_tick_cnt		= s3c24xx_rtc_save_tick_cnt,
+	.restore_tick_cnt	= s3c24xx_rtc_restore_tick_cnt,
+	.enable			= s3c24xx_rtc_enable,
+	.disable		= s3c24xx_rtc_disable,
+};
+
+static struct s3c_rtc_data const s3c2416_rtc_data = {
+	.max_user_freq		= 32768,
+	.irq_handler		= s3c24xx_rtc_irq,
+	.set_freq		= s3c2416_rtc_setfreq,
+	.enable_tick		= s3c24xx_rtc_enable_tick,
+	.select_tick_clk	= s3c2416_rtc_select_tick_clk,
+	.save_tick_cnt		= s3c24xx_rtc_save_tick_cnt,
+	.restore_tick_cnt	= s3c24xx_rtc_restore_tick_cnt,
+	.enable			= s3c24xx_rtc_enable,
+	.disable		= s3c24xx_rtc_disable,
+};
+
+static struct s3c_rtc_data const s3c2443_rtc_data = {
+	.max_user_freq		= 32768,
+	.irq_handler		= s3c24xx_rtc_irq,
+	.set_freq		= s3c2443_rtc_setfreq,
+	.enable_tick		= s3c24xx_rtc_enable_tick,
+	.select_tick_clk	= s3c2416_rtc_select_tick_clk,
+	.save_tick_cnt		= s3c24xx_rtc_save_tick_cnt,
+	.restore_tick_cnt	= s3c24xx_rtc_restore_tick_cnt,
+	.enable			= s3c24xx_rtc_enable,
+	.disable		= s3c24xx_rtc_disable,
+};
+
+static struct s3c_rtc_data const s3c6410_rtc_data = {
+	.max_user_freq		= 32768,
+	.irq_handler		= s3c6410_rtc_irq,
+	.set_freq		= s3c6410_rtc_setfreq,
+	.enable_tick		= s3c6410_rtc_enable_tick,
+	.save_tick_cnt		= s3c6410_rtc_save_tick_cnt,
+	.restore_tick_cnt	= s3c6410_rtc_restore_tick_cnt,
+	.enable			= s3c24xx_rtc_enable,
+	.disable		= s3c6410_rtc_disable,
 };
 
 static const struct of_device_id s3c_rtc_dt_match[] = {
 	{
 		.compatible = "samsung,s3c2410-rtc",
-		.data = &s3c_rtc_drv_data_array[TYPE_S3C2410],
+		.data = (void *)&s3c2410_rtc_data,
 	}, {
 		.compatible = "samsung,s3c2416-rtc",
-		.data = &s3c_rtc_drv_data_array[TYPE_S3C2416],
+		.data = (void *)&s3c2416_rtc_data,
 	}, {
 		.compatible = "samsung,s3c2443-rtc",
-		.data = &s3c_rtc_drv_data_array[TYPE_S3C2443],
+		.data = (void *)&s3c2443_rtc_data,
 	}, {
 		.compatible = "samsung,s3c6410-rtc",
-		.data = &s3c_rtc_drv_data_array[TYPE_S3C64XX],
+		.data = (void *)&s3c6410_rtc_data,
 	},
-	{},
+	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, s3c_rtc_dt_match);
-#endif
-
-static struct platform_device_id s3c_rtc_driver_ids[] = {
-	{
-		.name		= "s3c2410-rtc",
-		.driver_data	= TYPE_S3C2410,
-	}, {
-		.name		= "s3c2416-rtc",
-		.driver_data	= TYPE_S3C2416,
-	}, {
-		.name		= "s3c2443-rtc",
-		.driver_data	= TYPE_S3C2443,
-	}, {
-		.name		= "s3c64xx-rtc",
-		.driver_data	= TYPE_S3C64XX,
-	},
-	{ }
-};
-
-MODULE_DEVICE_TABLE(platform, s3c_rtc_driver_ids);
 
 static struct platform_driver s3c_rtc_driver = {
 	.probe		= s3c_rtc_probe,
 	.remove		= s3c_rtc_remove,
-	.id_table	= s3c_rtc_driver_ids,
 	.driver		= {
 		.name	= "s3c-rtc",
 		.owner	= THIS_MODULE,
@@ -693,7 +808,6 @@ static struct platform_driver s3c_rtc_driver = {
 		.of_match_table	= of_match_ptr(s3c_rtc_dt_match),
 	},
 };
-
 module_platform_driver(s3c_rtc_driver);
 
 MODULE_DESCRIPTION("Samsung S3C RTC Driver");
-- 
1.8.0


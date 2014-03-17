Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbaCQF7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 01:59:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33338 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403AbaCQF7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 01:59:36 -0400
X-AuditID: cbfee690-b7f266d00000287c-f7-53268f46575c
Message-id: <53268F48.8060704@samsung.com>
Date: Mon, 17 Mar 2014 14:59:36 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 3/8] devfreq: exynos4: Add ppmu's clock control and code
 clean about regulator control
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
 <1394698649-20996-4-git-send-email-cw00.choi@samsung.com>
 <53233F78.8020500@samsung.com> <5326632A.8030801@samsung.com>
In-reply-to: <5326632A.8030801@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWyRsSkRNe9Xy3YoHs5o0VHz28Wi/lHzrFa
	nHu1ktHibNMbdouFbUtYLC7vmsNm8bn3CKPFjPP7mCyWXr/IZHG7cQWbxZsfZ5ksJkxfy2Lx
	eMVbdotXB9tYLNbPeM3iwO+xZt4aRo+Vy7+weSze85LJ4+fy7ewefVtWMXocv7GdyePzJjmP
	jXNDAziiuGxSUnMyy1KL9O0SuDL+nnQpuGhUcb39EksD41eNLkYODgkBE4l5v+u6GDmBTDGJ
	C/fWs3UxcnEICSxllPiw7wULRMJEYm33WiaIxCJGic1dO9khnFeMEuu/XGEFqeIV0JJ4smUm
	O4jNIqAqcezLZ0YQmw0ovv/FDTYQW1QgTGLl9CssEPWCEj8m3wOzRQRUJC6fmg5WzyzwlUni
	5jwmEFtYIE9i1qbfUJsPMko8broAVsQpoC3R0/SLGaJBR2J/6zQ2CFteYvOat8wgDRICMzkk
	FlxaAXWRgMS3yYdYIH6Wldh0gBniNUmJgytusExgFJuF5KZZSMbOQjJ2ASPzKkbR1ILkguKk
	9CITveLE3OLSvHS95PzcTYzAGD/979mEHYz3DlgfYkwGWjmRWUo0OR+YIvJK4g2NzYwsTE1M
	jY3MLc1IE1YS51V7lBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTGBv1Qgp0HwZc0/4Ydf
	vEwiFtwO7MkQfz5Vaq2RmJ5/g2H7RTPuc2ymeSz+N5Jm1q+9Ptl+VviKS1o/jALyeN9ZP3nz
	/VZ56q4TsmetX84XdPb9vG3XvkXrdP6rBS5L5zH8KVV2Lemm3uWGs40/dlXNnB+48NTcCVoM
	6+9NTb+y+ILg1kjZe5OUWIozEg21mIuKEwHWxYvJBwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsVy+t9jAV23frVgg1WPTCw6en6zWMw/co7V
	4tyrlYwWZ5vesFssbFvCYnF51xw2i8+9RxgtZpzfx2Sx9PpFJovbjSvYLN78OMtkMWH6WhaL
	xyveslu8OtjGYrF+xmsWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsAR1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0vZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx4+9Jl4KLRhXX2y+x
	NDB+1ehi5OSQEDCRWNu9lgnCFpO4cG89WxcjF4eQwCJGic1dO9khnFeMEuu/XGEFqeIV0JJ4
	smUmO4jNIqAqcezLZ0YQmw0ovv/FDTYQW1QgTGLl9CssEPWCEj8m3wOzRQRUJC6fmg5Wzyzw
	lUni5jywzcICeRKzNv1mglh2kFHicdMFsCJOAW2JnqZfzBANOhL7W6exQdjyEpvXvGWewCgw
	C8mOWUjKZiEpW8DIvIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOIU8k9rBuLLB4hCjAAej
	Eg/vBGW1YCHWxLLiytxDjBIczEoivHqxQCHelMTKqtSi/Pii0pzU4kOMycAgmMgsJZqcD0xv
	eSXxhsYmZkaWRuaGFkbG5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAyL+ktqlL5kIO
	k87JlZu5M9s0X63s1my1frSer9KytWBWbxLvhNKtSXP+b8gLe1T9I9lJTjb6yP7yBXtKK7sa
	Hz3uEMu6dnu17o8r03NmG7GmudSz/lAXW8inI3LhecPT5KKFly8YO7/uUmp7aiIxu0lpfZd4
	tPrFEw0K95UbOrwe37y0t/6JEktxRqKhFnNRcSIAJyEYOmUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 03/17/2014 11:51 AM, Chanwoo Choi wrote:
> Hi Tomasz,
> 
> On 03/15/2014 02:42 AM, Tomasz Figa wrote:
>> Hi Chanwoo,
>>
>> On 13.03.2014 09:17, Chanwoo Choi wrote:
>>> There are not the clock controller of ppmudmc0/1. This patch control the clock
>>> of ppmudmc0/1 which is used for monitoring memory bus utilization.
>>>
>>> Also, this patch code clean about regulator control and free resource
>>> when calling exit/remove function.
>>>
>>> For example,
>>> busfreq@106A0000 {
>>>     compatible = "samsung,exynos4x12-busfreq";
>>>
>>>     /* Clock for PPMUDMC0/1 */
>>>     clocks = <&clock CLK_PPMUDMC0>, <&clock CLK_PPMUDMC1>;
>>>     clock-names = "ppmudmc0", "ppmudmc1";
>>>
>>>     /* Regulator for MIF/INT block */
>>>     vdd_mif-supply = <&buck1_reg>;
>>>     vdd_int-supply = <&buck3_reg>;
>>> };
>>>
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

I modify this patch according your comment as following:

Best Regards,
Chanwoo Choi

>From c8f2fbc4c1166ec02fb2ad46164bc7ed9118721b Mon Sep 17 00:00:00 2001
From: Chanwoo Choi <cw00.choi@samsung.com>
Date: Fri, 14 Mar 2014 12:05:54 +0900
Subject: [PATCH] devfreq: exynos4: Add ppmu's clock control and code clean
 about regulator control

There are not the clock controller of ppmudmc0/1. This patch control the clock
of ppmudmc0/1 which is used for monitoring memory bus utilization.

Also, this patch code clean about regulator control and free resource
when calling exit/remove function.

For example,
busfreq@106A0000 {
	compatible = "samsung,exynos4x12-busfreq";

	/* Clock for PPMUDMC0/1 */
	clocks = <&clock CLK_PPMUDMC0>, <&clock CLK_PPMUDMC1>;
	clock-names = "ppmudmc0", "ppmudmc1";

	/* Regulator for MIF/INT block */
	vdd_mif-supply = <&buck1_reg>;
	vdd_int-supply = <&buck3_reg>;
};

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/exynos/exynos4_bus.c | 97 +++++++++++++++++++++++++++++++-----
 1 file changed, 84 insertions(+), 13 deletions(-)

diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index 4c630fb..3956bcc 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -62,6 +62,11 @@ enum exynos_ppmu_idx {
 	PPMU_END,
 };
 
+static const char *exynos_ppmu_clk_name[] = {
+	[PPMU_DMC0]	= "ppmudmc0",
+	[PPMU_DMC1]	= "ppmudmc1",
+};
+
 #define EX4210_LV_MAX	LV_2
 #define EX4x12_LV_MAX	LV_4
 #define EX4210_LV_NUM	(LV_2 + 1)
@@ -86,6 +91,7 @@ struct busfreq_data {
 	struct regulator *vdd_mif; /* Exynos4412/4212 only */
 	struct busfreq_opp_info curr_oppinfo;
 	struct exynos_ppmu ppmu[PPMU_END];
+	struct clk *clk_ppmu[PPMU_END];
 
 	struct notifier_block pm_notifier;
 	struct mutex lock;
@@ -724,6 +730,17 @@ static void exynos4_bus_exit(struct device *dev)
 	struct busfreq_data *data = dev_get_drvdata(dev);
 	int i;
 
+	/*
+	 * Un-map memory map and disable regulator/clocks
+	 * to prevent power leakage.
+	 */
+	regulator_disable(data->vdd_int);
+	if (data->type == TYPE_BUSF_EXYNOS4x12)
+		regulator_disable(data->vdd_mif);
+
+	for (i = 0; i < PPMU_END; i++)
+		clk_disable_unprepare(data->clk_ppmu[i]);
+
 	for (i = 0; i < PPMU_END; i++)
 		iounmap(data->ppmu[i].hw_base);
 }
@@ -989,6 +1006,7 @@ static int exynos4_busfreq_parse_dt(struct busfreq_data *data)
 {
 	struct device *dev = data->dev;
 	struct device_node *np = dev->of_node;
+	const char **clk_name = exynos_ppmu_clk_name;
 	int i, ret = 0;
 
 	if (!np) {
@@ -1006,8 +1024,67 @@ static int exynos4_busfreq_parse_dt(struct busfreq_data *data)
 		}
 	}
 
+	for (i = 0; i < PPMU_END; i++) {
+		data->clk_ppmu[i] = devm_clk_get(dev, clk_name[i]);
+		if (IS_ERR(data->clk_ppmu[i])) {
+			dev_warn(dev, "Failed to get %s clock\n", clk_name[i]);
+			goto err_clocks;
+		}
+
+		ret = clk_prepare_enable(data->clk_ppmu[i]);
+		if (ret < 0) {
+			dev_warn(dev, "Failed to enable %s clock\n", clk_name[i]);
+			data->clk_ppmu[i] = NULL;
+			goto err_clocks;
+		}
+	}
+
+	/* Get regulator to control voltage of int block */
+	data->vdd_int = devm_regulator_get(dev, "vdd_int");
+	if (IS_ERR(data->vdd_int)) {
+		dev_err(dev, "Failed to get the regulator of vdd_int\n");
+		ret = PTR_ERR(data->vdd_int);
+		goto err_clocks;
+	}
+	ret = regulator_enable(data->vdd_int);
+	if (ret < 0) {
+		dev_err(dev, "Failed to enable regulator of vdd_int\n");
+		goto err_clocks;
+	}
+
+	switch (data->type) {
+	case TYPE_BUSF_EXYNOS4210:
+		break;
+	case TYPE_BUSF_EXYNOS4x12:
+		/* Get regulator to control voltage of mif blk if Exynos4x12 */
+		data->vdd_mif = devm_regulator_get(dev, "vdd_mif");
+		if (IS_ERR(data->vdd_mif)) {
+			dev_err(dev, "Failed to get the regulator vdd_mif\n");
+			ret = PTR_ERR(data->vdd_mif);
+			goto err_regulator;
+		}
+		ret = regulator_enable(data->vdd_mif);
+		if (ret < 0) {
+			dev_err(dev, "Failed to enable regulator of vdd_mif\n");
+			goto err_regulator;
+		}
+		break;
+	default:
+		dev_err(dev, "Unknown device type : %d\n", data->type);
+		return -EINVAL;
+	};
+
 	return 0;
 
+err_regulator:
+	regulator_disable(data->vdd_int);
+err_clocks:
+	for (i = 0; i < PPMU_END; i++) {
+		if (IS_ERR(data->clk_ppmu[i]))
+			continue;
+		else
+			clk_disable_unprepare(data->clk_ppmu[i]);
+	}
 err_iomap:
 	for (i = 0; i < PPMU_END; i++) {
 		if (IS_ERR_OR_NULL(data->ppmu[i].hw_base))
@@ -1074,19 +1151,6 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	data->vdd_int = devm_regulator_get(dev, "vdd_int");
-	if (IS_ERR(data->vdd_int)) {
-		dev_err(dev, "Cannot get the regulator \"vdd_int\"\n");
-		return PTR_ERR(data->vdd_int);
-	}
-	if (data->type == TYPE_BUSF_EXYNOS4x12) {
-		data->vdd_mif = devm_regulator_get(dev, "vdd_mif");
-		if (IS_ERR(data->vdd_mif)) {
-			dev_err(dev, "Cannot get the regulator \"vdd_mif\"\n");
-			return PTR_ERR(data->vdd_mif);
-		}
-	}
-
 	rcu_read_lock();
 	opp = dev_pm_opp_find_freq_floor(dev,
 					 &exynos4_devfreq_profile.initial_freq);
@@ -1146,6 +1210,13 @@ err_notifier_opp:
 	return err;
 
 err_devfreq:
+	regulator_disable(data->vdd_int);
+	if (data->type == TYPE_BUSF_EXYNOS4x12)
+		regulator_disable(data->vdd_mif);
+
+	for (i = 0; i < PPMU_END; i++)
+		clk_disable_unprepare(data->clk_ppmu[i]);
+
 	for (i = 0; i < PPMU_END; i++)
 		iounmap(data->ppmu[i].hw_base);
 
-- 
1.8.0



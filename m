Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965792AbaDJJjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:39:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:9297 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965729AbaDJJh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:37:59 -0400
X-AuditID: cbfee690-b7f266d00000287c-12-534666758af6
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 08/27] pinctrl: exynos: Add driver data for Exynos3250
Date: Thu, 10 Apr 2014 18:37:19 +0900
Message-id: <1397122658-16013-9-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42JZI2JSpFua5hZscOGugsX1L89ZLT5/aGG3
	mHR/AotF74KrbBZnm96wW0z5s5zJYtPja6wWl3fNYbOYcX4fk8WMyS/ZLNbPeM1icWzGEkaL
	vTsnMzrwety5tofNY/OSeo++LasYPT5vkgtgieKySUnNySxLLdK3S+DKONexmq3glFrF7WXH
	WBoYpyp2MXJySAiYSEzbNpsZwhaTuHBvPVsXIxeHkMBSRonv9y+wdDFygBVNnCAIEZ/OKNG6
	czcbSIOQQBOTxMyXAiA2m4CWxP4XN8DiIgIBEj+Ov2MD6WUW2MwkcdIEJCws4CZx9EAjWAmL
	gKrEi/VbwGxeAVeJ/22/mCBukJP4sOcRO4jNCVQ/c9FJqFWuEj2PLjKD3CAhcIhdYt/Og8wQ
	gwQkvk0+BHWnrMSmA1C/SEocXHGDZQKj8AJGhlWMoqkFyQXFSelFJnrFibnFpXnpesn5uZsY
	gTFx+t+zCTsY7x2wPsSYDDRuIrOUaHI+MKbySuINjc2MLExNTI2NzC3NSBNWEudVe5QUJCSQ
	nliSmp2aWpBaFF9UmpNafIiRiYNTqoGxtvvbG/Nra2Rmnw//9zvDIVn37BrrlscdchOPFyju
	edoeXy63599/9U/OKsdY+RfVzNb9VjttZoTK/gOB7x8KuHjO6PvcHeA/14Jnxo1PJ89s9Dw1
	s60tqER6vz2Pgt2DSqPPQUbdUR3N26OvZfx99u1S8OlThWvdWJxWc9Y9yHs1fXcUL4+wEktx
	RqKhFnNRcSIAjvL/fJ8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t9jQd3SNLdgg9PN4hbXvzxntfj8oYXd
	YtL9CSwWvQuuslmcbXrDbjHlz3Imi02Pr7FaXN41h81ixvl9TBYzJr9ks1g/4zWLxbEZSxgt
	9u6czOjA63Hn2h42j81L6j36tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91WyTs43jne
	1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6D4lhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4h
	QXA9RgZoIGENY8a5jtVsBafUKm4vO8bSwDhVsYuRg0NCwERi4gTBLkZOIFNM4sK99WxdjFwc
	QgLTGSVad+5mA0kICTQxScx8KQBiswloSex/cQMsLiIQIPHj+Ds2kDnMApuZJE6agISFBdwk
	jh5oBCthEVCVeLF+C5jNK+Aq8b/tFxPELjmJD3sesYPYnED1MxedhFrlKtHz6CLzBEbeBYwM
	qxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCI+6Z1A7GlQ0WhxgFOBiVeHgPLHMNFmJNLCuu
	zD3EKMHBrCTCey3YLViINyWxsiq1KD++qDQntfgQYzLQVROZpUST84HJIK8k3tDYxMzI0sjc
	0MLI2Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGH3PVS/RmiRvWtfKV2beNmtms5TD
	pydXurbNsOpNUMjmZ/7Et+9v2M69+vrqP1a3dyxpu3bd9c8vrQdcRQI2+x6697We4F74RWXR
	IqMdyzn/eRXYfPg+XzIjSGlVRX80g1aU+ucVInzW2+U3mHHVHy+75fr7/MRdD7rPbj5icHHr
	g2kuPuIXDyuxFGckGmoxFxUnAgD9BQx1/AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

This patch adds driver data (bank list and EINT layout) for Exynos3250
to pinctrl-exynos driver. Exynos3250 includes 158 multi-functional input/output
ports. There are 23 general port groups.

Cc: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/pinctrl/pinctrl-exynos.c  | 67 +++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.c |  2 ++
 drivers/pinctrl/pinctrl-samsung.h |  1 +
 3 files changed, 70 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/pinctrl-exynos.c
index 07c8130..9609c23 100644
--- a/drivers/pinctrl/pinctrl-exynos.c
+++ b/drivers/pinctrl/pinctrl-exynos.c
@@ -718,6 +718,73 @@ struct samsung_pin_ctrl s5pv210_pin_ctrl[] = {
 	},
 };
 
+/* pin banks of exynos3250 pin-controller 0 */
+static struct samsung_pin_bank exynos3250_pin_banks0[] = {
+	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
+	EXYNOS_PIN_BANK_EINTG(6, 0x020, "gpa1", 0x04),
+	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpb",  0x08),
+	EXYNOS_PIN_BANK_EINTG(5, 0x060, "gpc0", 0x0c),
+	EXYNOS_PIN_BANK_EINTG(5, 0x080, "gpc1", 0x10),
+	EXYNOS_PIN_BANK_EINTG(4, 0x0a0, "gpd0", 0x14),
+	EXYNOS_PIN_BANK_EINTG(4, 0x0c0, "gpd1", 0x18),
+};
+
+/* pin banks of exynos3250 pin-controller 1 */
+static struct samsung_pin_bank exynos3250_pin_banks1[] = {
+	EXYNOS_PIN_BANK_EINTN(8, 0x120, "gpe0"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x140, "gpe1"),
+	EXYNOS_PIN_BANK_EINTN(3, 0x180, "gpe2"),
+	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpk0", 0x08),
+	EXYNOS_PIN_BANK_EINTG(7, 0x060, "gpk1", 0x0c),
+	EXYNOS_PIN_BANK_EINTG(7, 0x080, "gpk2", 0x10),
+	EXYNOS_PIN_BANK_EINTG(4, 0x0c0, "gpl0", 0x18),
+	EXYNOS_PIN_BANK_EINTG(8, 0x260, "gpm0", 0x24),
+	EXYNOS_PIN_BANK_EINTG(7, 0x280, "gpm1", 0x28),
+	EXYNOS_PIN_BANK_EINTG(5, 0x2a0, "gpm2", 0x2c),
+	EXYNOS_PIN_BANK_EINTG(8, 0x2c0, "gpm3", 0x30),
+	EXYNOS_PIN_BANK_EINTG(8, 0x2e0, "gpm4", 0x34),
+	EXYNOS_PIN_BANK_EINTW(8, 0xc00, "gpx0", 0x00),
+	EXYNOS_PIN_BANK_EINTW(8, 0xc20, "gpx1", 0x04),
+	EXYNOS_PIN_BANK_EINTW(8, 0xc40, "gpx2", 0x08),
+	EXYNOS_PIN_BANK_EINTW(8, 0xc60, "gpx3", 0x0c),
+};
+
+/*
+ * Samsung pinctrl driver data for Exynos3250 SoC. Exynos3250 SoC includes
+ * two gpio/pin-mux/pinconfig controllers.
+ */
+struct samsung_pin_ctrl exynos3250_pin_ctrl[] = {
+	{
+		/* pin-controller instance 0 data */
+		.pin_banks	= exynos3250_pin_banks0,
+		.nr_banks	= ARRAY_SIZE(exynos3250_pin_banks0),
+		.geint_con	= EXYNOS_GPIO_ECON_OFFSET,
+		.geint_mask	= EXYNOS_GPIO_EMASK_OFFSET,
+		.geint_pend	= EXYNOS_GPIO_EPEND_OFFSET,
+		.svc		= EXYNOS_SVC_OFFSET,
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos3250-gpio-ctrl0",
+	}, {
+		/* pin-controller instance 1 data */
+		.pin_banks	= exynos3250_pin_banks1,
+		.nr_banks	= ARRAY_SIZE(exynos3250_pin_banks1),
+		.geint_con	= EXYNOS_GPIO_ECON_OFFSET,
+		.geint_mask	= EXYNOS_GPIO_EMASK_OFFSET,
+		.geint_pend	= EXYNOS_GPIO_EPEND_OFFSET,
+		.weint_con	= EXYNOS_WKUP_ECON_OFFSET,
+		.weint_mask	= EXYNOS_WKUP_EMASK_OFFSET,
+		.weint_pend	= EXYNOS_WKUP_EPEND_OFFSET,
+		.svc		= EXYNOS_SVC_OFFSET,
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.eint_wkup_init = exynos_eint_wkup_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos3250-gpio-ctrl1",
+	},
+};
+
 /* pin banks of exynos4210 pin-controller 0 */
 static struct samsung_pin_bank exynos4210_pin_banks0[] = {
 	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index 0324d4c..3e61d0f 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -1114,6 +1114,8 @@ static struct syscore_ops samsung_pinctrl_syscore_ops = {
 
 static const struct of_device_id samsung_pinctrl_dt_match[] = {
 #ifdef CONFIG_PINCTRL_EXYNOS
+	{ .compatible = "samsung,exynos3250-pinctrl",
+		.data = (void *)exynos3250_pin_ctrl },
 	{ .compatible = "samsung,exynos4210-pinctrl",
 		.data = (void *)exynos4210_pin_ctrl },
 	{ .compatible = "samsung,exynos4x12-pinctrl",
diff --git a/drivers/pinctrl/pinctrl-samsung.h b/drivers/pinctrl/pinctrl-samsung.h
index bab9c21..b3e41fa 100644
--- a/drivers/pinctrl/pinctrl-samsung.h
+++ b/drivers/pinctrl/pinctrl-samsung.h
@@ -251,6 +251,7 @@ struct samsung_pmx_func {
 };
 
 /* list of all exported SoC specific data */
+extern struct samsung_pin_ctrl exynos3250_pin_ctrl[];
 extern struct samsung_pin_ctrl exynos4210_pin_ctrl[];
 extern struct samsung_pin_ctrl exynos4x12_pin_ctrl[];
 extern struct samsung_pin_ctrl exynos5250_pin_ctrl[];
-- 
1.8.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaDNBqI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 21:46:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31902 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaDNBqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 21:46:05 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-0a-534b3dd83fe5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kyungmin.park@samsung.com, Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2] pinctrl: exynos: Add driver data for Exynos3250
Date: Mon, 14 Apr 2014 10:45:47 +0900
Message-id: <1397439947-31592-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWyRsSkSPemrXewwdmtLBbXvzxntehdcJXN
	4mzTG3aLKX+WM1lsenyN1eLyrjlsFjPO72OyWD/jNYvFsRlLGB04Pe5c28PmsXlJvUffllWM
	Hp83yQWwRHHZpKTmZJalFunbJXBl9D3pZi+YoVGxtX8dYwPjIaUuRg4OCQETicYlsV2MnECm
	mMSFe+vZuhi5OIQEljJKfNm7iQUiYSLx4/AEJojEdEaJS/1PWCGcJiaJp9P3MYJUsQloSex/
	cYMNxBYRUJDY3PuMFcRmFtjAJHHjoz6ILSzgJLF7/hk2kM0sAqoS3/sNQMK8Aq4SXfceQS2T
	k/iw5xE7hN3NLrGpmRPEZhEQkPg2+RALxNGyEpsOMEOUSEocXHGDZQKj4AJGhlWMoqkFyQXF
	SelFhnrFibnFpXnpesn5uZsYgaF7+t+z3h2Mtw9YH2JMBho3kVlKNDkfGPp5JfGGxmZGFqYm
	psZG5pZmpAkrifMmPUwKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cCY+kiq7IHZm3WCsrb7
	H33J8cx8oJzfWMGieutGk13fkb3xPwJd7yYJ/Vji1nimNenPsu6afQxHlnj8O5h/o3nVZZut
	yzI1c4Lfi2rN1F9fe6bsQIx6fOfyu82Llz+o/Ka69sdbo/8rppQVCKmfa2gtvrTaODpTIbPk
	yWuPzQH76os/NO8+MctYiaU4I9FQi7moOBEATmk3QnMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t9jQd0btt7BBj//mFhc//Kc1aJ3wVU2
	i7NNb9gtpvxZzmSx6fE1VovLu+awWcw4v4/JYv2M1ywWx2YsYXTg9LhzbQ+bx+Yl9R59W1Yx
	enzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6Dr
	lpkDdIuSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMaPvSTd7wQyNiq39
	6xgbGA8pdTFyckgImEj8ODyBCcIWk7hwbz1bFyMXh5DAdEaJS/1PWCGcJiaJp9P3MYJUsQlo
	Sex/cYMNxBYRUJDY3PuMFcRmFtjAJHHjoz6ILSzgJLF7/hmgGg4OFgFVie/9BiBhXgFXia57
	j1gglslJfNjziH0CI/cCRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHR8Ux6B+OqBotD
	jAIcjEo8vAnbPYOFWBPLiitzDzFKcDArifBuy/AKFuJNSaysSi3Kjy8qzUktPsSYDLR8IrOU
	aHI+MHLzSuINjU3MjCyNzA0tjIzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoGRY+GO
	dQ3LAup8hFn7z077Wv/uylUJ6zcHpWy29CREPD106MSd7Z/7l8YtlPzwNYhrVbTslAlLiuTk
	pYoqXoetu85l/zRl80rxtE1GfwW6v1qGHt35fZ7Adq6EqFcPGzon/VfIzN1ac97v76McpffW
	icWPX0p+u2Slenkm/zbxZXNrdgX+uxCSpcRSnJFoqMVcVJwIAPSEDeLSAgAA
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

Changes from v1:
- Add signed-off of sender
- Post only separated patch for pinctrl from following patchset(v1)
  : https://lkml.org/lkml/2014/4/10/286

Cc: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
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


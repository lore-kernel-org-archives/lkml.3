Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935315AbaDJJcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:32:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45458 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935120AbaDJJ26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:28:58 -0400
X-AuditID: cbfee68f-b7f156d00000276c-d7-534664514ac5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 08/27] pinctrl: exynos: Add driver data for Exynos3250
Date: Thu, 10 Apr 2014 18:28:25 +0900
Message-id: <1397122124-15690-9-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkRDcwxS3YoGOmvMX1L89ZLT5/aGG3
	mHR/AotF74KrbBZnm96wW2x6fI3V4vKuOWwWM87vY7KYMfklm8X6Ga9ZLPbunMzowO2xeUm9
	R9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGW8XX6BpeCIasX174eZGxjnKXQxcnJICJhIdC3o
	YoewxSQu3FvPBmILCSxllDi2uQCm5sG9w0BxLqD4dEaJ1203GCGcJiaJ5l+HGUGq2AS0JPa/
	uAHWLSIQIPHj+Dswm1ngJtCk92EgtrCAm8TRA41AcQ4OFgFViacvRUHCvAKuEicOdrBALJOT
	+LDnEdhBnEDln763skIc5CrR9GEf2BESAsvYJa7cvQlWxCIgIPFt8iEWkJkSArISmw4wQ8yR
	lDi44gbLBEbhBYwMqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzECw/70v2f9OxjvHrA+xJgM
	NG4is5Rocj4wbvJK4g2NzYwsTE1MjY3MLc1IE1YS573/MClISCA9sSQ1OzW1ILUovqg0J7X4
	ECMTB6dUA6NF0Oq6/MsPz0cIrD0844/5VeGW5Eenn/PdVA97fzR51rMDCvFPrjVpuAqFv759
	7KapuaFDy/wMNb1mm822B8/cWbD87tXdbUEey8TmxuRqsq3SeMbCLdfTncbcfLhovb+Ais9U
	q4uG7/t6z86d987yy4VVuoHv40JlH/KlzFH1cImO2TbdjEmJpTgj0VCLuag4EQDmjzUMkQIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jQd3AFLdgg+sPRS2uf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxtvlF1gK
	jqhWXP9+mLmBcZ5CFyMnh4SAicSDe4fZIGwxiQv31gPZXBxCAtMZJV633WCEcJqYJJp/HWYE
	qWIT0JLY/+IGWIeIQIDEj+PvwGxmgZuMEsfeh4HYwgJuEkcPNALFOThYBFQlnr4UBQnzCrhK
	nDjYwQKxTE7iw55H7CA2J1D5p++trCC2EFBN04d9bBMYeRcwMqxiFE0tSC4oTkrPNdQrTswt
	Ls1L10vOz93ECI6rZ1I7GFc2WBxiFOBgVOLhPbDMNViINbGsuDL3EKMEB7OSCO+1YLdgId6U
	xMqq1KL8+KLSnNTiQ4zJQEdNZJYSTc4HxnxeSbyhsYmZkaWRuaGFkbE5acJK4rwHWq0DhQTS
	E0tSs1NTC1KLYLYwcXBKNTDK+/pa/Q/Ovb1RrNrzksuSjv1vPq6qa66pc5c7pNr/eYJCxpfz
	J8VnhJj8VjVNneNZeeVpxaLrOzg45q5oerNLz0tdzlO8ujORq8so0M/qzd4jrnz63tZnnu4K
	Tf1QKhliG6jmyBAivWDHEw1eXyvPCRKs0YmmFyxORS81vbAhJZbt4rOpu5VYijMSDbWYi4oT
	ARXvMK3vAgAA
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


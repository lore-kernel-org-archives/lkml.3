Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbbAUGnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:43:17 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:9018 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbbAUGnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:43:15 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-c0-54bf4a80eecb
From: Chanwoo Choi <cw00.choi@samsung.com>
To: tomasz.figa@gmail.com, thomas.abraham@linaro.org, linus.walleij@linaro.org
Cc: kgene@kernel.org, inki.dae@samsung.com, chanho61.park@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH v3] pinctrl: exynos: Add support for Exynos5433
Date: Wed, 21 Jan 2015 15:43:11 +0900
Message-id: <1421822591-10536-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWyRsSkULfRa3+IwY15rBaX92tbXP/ynNVi
	0v0JLBb9j18zW0z5s5zJYtPja0DJXXPYLGac38dkcWzGEkaLVbv+MDpweeycdZfdY9OqTjaP
	O9f2sHlsXlLv0bdlFaPH501yAWxRXDYpqTmZZalF+nYJXBmn5txkK5jmUtHSsJS5gXGGVRcj
	J4eEgInE/Lf9jBC2mMSFe+vZuhi5OIQEljJKfLh1ggmm6MCeKewQiemMEl+/9TNDOE1MEu+m
	9rCDVLEJaEnsf3GDDcQWEfCTeN/SwQpSxCxwjVGi88p7sFHCAvYSj6dMZAaxWQRUJe6ebQBr
	4BVwlTiycTPUHQoSy5bPBGuWEJjHLnGn+zQbRIOAxLfJh1i6GDmAErISmw4wQ9RLShxccYNl
	AqPgAkaGVYyiqQXJBcVJ6UUmesWJucWleel6yfm5mxiB4X3637MJOxjvHbA+xCjAwajEw/tC
	cX+IEGtiWXFl7iFGU6ANE5mlRJPzgVGUVxJvaGxmZGFqYmpsZG5ppiTO+1rqZ7CQQHpiSWp2
	ampBalF8UWlOavEhRiYOTqkGRidu0Q19mzU1ms7Xf76g4XZj4bMX6TYda1cc7jIw0HaQNFMz
	41neb+14O7nEwZCl5VONbSOjdYXkKierOwuYmtom1P6S2u8R+2WH9KO/hsxyvibqZhNLDcXU
	7v2bd9aqc1FLSvbnN3r7JkxSUBe+Jb7kfO2M5Aen8q/Unfmx4MPFbu9lR62ZlFiKMxINtZiL
	ihMB6TYJcmoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQd0Gr/0hBiuWWlhc3q9tcf3Lc1aL
	SfcnsFj0P37NbDHlz3Imi02Pr7FaXN41h81ixvl9TBbHZixhtFi16w+jA5fHzll32T02repk
	87hzbQ+bx+Yl9R59W1YxenzeJBfAFtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGto
	aWGupJCXmJtqq+TiE6DrlpkDdJmSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0
	kLCGMePUnJtsBdNcKloaljI3MM6w6mLk5JAQMJE4sGcKO4QtJnHh3nq2LkYuDiGB6YwSX7/1
	M0M4TUwS76b2gFWxCWhJ7H9xgw3EFhHwk3jf0sEKUsQscI1RovPKeyaQhLCAvcTjKROZQWwW
	AVWJu2cbwBp4BVwljmzczAixTkFi2fKZrBMYuRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vO
	z93ECI6eZ1I7GFc2WBxiFOBgVOLhfaG4P0SINbGsuDL3EKMEB7OSCK+iBFCINyWxsiq1KD++
	qDQntfgQoynQ9onMUqLJ+cDIziuJNzQ2MTOyNDI3tDAyNlcS51WybwsREkhPLEnNTk0tSC2C
	6WPi4JRqYCxml4ndsMVlkkW2dKfM1Ueen7+Ia3Cy6C0vSisQ+uj+lHle8sRlyoL599it5uyT
	L8lIfHPuYcLH1tnHFuZv5CrfcXkSd8PC+Gm2R5ut0nfeufFiU9zeV7MKF3VsMwhPO3c6aObS
	z8m62bKzdU5MLRKcevxpM++nI/ypVw/FhUotaL21e4F6PZsSS3FGoqEWc1FxIgBNdPhstAIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds driver data for Exynos5433 SoC. Exynos5433 includes 228 multi-
functional input/output port pins and 135 memory port pins. There are 41 general
port groups and 2 memory port groups.

Cc: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
Changes from v2:
- Rebase it on v3.19-rc5

Changes from v1:
- Fix the wrong number of Exynos5433 (four -> ten)
- Divide pinctrl patch from following patch[1]
 [1] https://lkml.org/lkml/2014/12/2/134

 drivers/pinctrl/samsung/pinctrl-exynos.c  | 153 ++++++++++++++++++++++++++++++
 drivers/pinctrl/samsung/pinctrl-samsung.c |   2 +
 drivers/pinctrl/samsung/pinctrl-samsung.h |   1 +
 3 files changed, 156 insertions(+)

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index becb379..4976441 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -1240,6 +1240,159 @@ const struct samsung_pin_ctrl exynos5420_pin_ctrl[] __initconst = {
 	},
 };
 
+/* pin banks of exynos5433 pin-controller - ALIVE */
+static const struct samsung_pin_bank_data exynos5433_pin_banks0[] = {
+	EXYNOS_PIN_BANK_EINTW(8, 0x000, "gpa0", 0x00),
+	EXYNOS_PIN_BANK_EINTW(8, 0x020, "gpa1", 0x04),
+	EXYNOS_PIN_BANK_EINTW(8, 0x040, "gpa2", 0x08),
+	EXYNOS_PIN_BANK_EINTW(8, 0x060, "gpa3", 0x0c),
+};
+
+/* pin banks of exynos5433 pin-controller - AUD */
+static const struct samsung_pin_bank_data exynos5433_pin_banks1[] = {
+	EXYNOS_PIN_BANK_EINTG(7, 0x000, "gpz0", 0x00),
+	EXYNOS_PIN_BANK_EINTG(4, 0x020, "gpz1", 0x04),
+};
+
+/* pin banks of exynos5433 pin-controller - CPIF */
+static const struct samsung_pin_bank_data exynos5433_pin_banks2[] = {
+	EXYNOS_PIN_BANK_EINTG(2, 0x000, "gpv6", 0x00),
+};
+
+/* pin banks of exynos5433 pin-controller - eSE */
+static const struct samsung_pin_bank_data exynos5433_pin_banks3[] = {
+	EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj2", 0x00),
+};
+
+/* pin banks of exynos5433 pin-controller - FINGER */
+static const struct samsung_pin_bank_data exynos5433_pin_banks4[] = {
+	EXYNOS_PIN_BANK_EINTG(4, 0x000, "gpd5", 0x00),
+};
+
+/* pin banks of exynos5433 pin-controller - FSYS */
+static const struct samsung_pin_bank_data exynos5433_pin_banks5[] = {
+	EXYNOS_PIN_BANK_EINTG(6, 0x000, "gph1", 0x00),
+	EXYNOS_PIN_BANK_EINTG(7, 0x020, "gpr4", 0x04),
+	EXYNOS_PIN_BANK_EINTG(5, 0x040, "gpr0", 0x08),
+	EXYNOS_PIN_BANK_EINTG(8, 0x060, "gpr1", 0x0c),
+	EXYNOS_PIN_BANK_EINTG(2, 0x080, "gpr2", 0x10),
+	EXYNOS_PIN_BANK_EINTG(8, 0x0a0, "gpr3", 0x14),
+};
+
+/* pin banks of exynos5433 pin-controller - IMEM */
+static const struct samsung_pin_bank_data exynos5433_pin_banks6[] = {
+	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpf0", 0x00),
+};
+
+/* pin banks of exynos5433 pin-controller - NFC */
+static const struct samsung_pin_bank_data exynos5433_pin_banks7[] = {
+	EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj0", 0x00),
+};
+
+/* pin banks of exynos5433 pin-controller - PERIC */
+static const struct samsung_pin_bank_data exynos5433_pin_banks8[] = {
+	EXYNOS_PIN_BANK_EINTG(6, 0x000, "gpv7", 0x00),
+	EXYNOS_PIN_BANK_EINTG(5, 0x020, "gpb0", 0x04),
+	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpc0", 0x08),
+	EXYNOS_PIN_BANK_EINTG(2, 0x060, "gpc1", 0x0c),
+	EXYNOS_PIN_BANK_EINTG(6, 0x080, "gpc2", 0x10),
+	EXYNOS_PIN_BANK_EINTG(8, 0x0a0, "gpc3", 0x14),
+	EXYNOS_PIN_BANK_EINTG(2, 0x0c0, "gpg0", 0x18),
+	EXYNOS_PIN_BANK_EINTG(4, 0x0e0, "gpd0", 0x1c),
+	EXYNOS_PIN_BANK_EINTG(6, 0x100, "gpd1", 0x20),
+	EXYNOS_PIN_BANK_EINTG(8, 0x120, "gpd2", 0x24),
+	EXYNOS_PIN_BANK_EINTG(5, 0x140, "gpd4", 0x28),
+	EXYNOS_PIN_BANK_EINTG(2, 0x160, "gpd8", 0x2c),
+	EXYNOS_PIN_BANK_EINTG(7, 0x180, "gpd6", 0x30),
+	EXYNOS_PIN_BANK_EINTG(3, 0x1a0, "gpd7", 0x34),
+	EXYNOS_PIN_BANK_EINTG(5, 0x1c0, "gpg1", 0x38),
+	EXYNOS_PIN_BANK_EINTG(2, 0x1e0, "gpg2", 0x3c),
+	EXYNOS_PIN_BANK_EINTG(8, 0x200, "gpg3", 0x40),
+};
+
+/* pin banks of exynos5433 pin-controller - TOUCH */
+static const struct samsung_pin_bank_data exynos5433_pin_banks9[] = {
+	EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj1", 0x00),
+};
+
+/*
+ * Samsung pinctrl driver data for Exynos5433 SoC. Exynos5433 SoC includes
+ * ten gpio/pin-mux/pinconfig controllers.
+ */
+const struct samsung_pin_ctrl exynos5433_pin_ctrl[] = {
+	{
+		/* pin-controller instance 0 data */
+		.pin_banks	= exynos5433_pin_banks0,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks0),
+		.eint_wkup_init = exynos_eint_wkup_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+	}, {
+		/* pin-controller instance 1 data */
+		.pin_banks	= exynos5433_pin_banks1,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks1),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+	}, {
+		/* pin-controller instance 2 data */
+		.pin_banks	= exynos5433_pin_banks2,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks2),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+	}, {
+		/* pin-controller instance 3 data */
+		.pin_banks	= exynos5433_pin_banks3,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks3),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+	}, {
+		/* pin-controller instance 4 data */
+		.pin_banks	= exynos5433_pin_banks4,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks4),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+	}, {
+		/* pin-controller instance 5 data */
+		.pin_banks	= exynos5433_pin_banks5,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks5),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+	}, {
+		/* pin-controller instance 6 data */
+		.pin_banks	= exynos5433_pin_banks6,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks6),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+	}, {
+		/* pin-controller instance 7 data */
+		.pin_banks	= exynos5433_pin_banks7,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks7),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+	}, {
+		/* pin-controller instance 8 data */
+		.pin_banks	= exynos5433_pin_banks8,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks8),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+	}, {
+		/* pin-controller instance 9 data */
+		.pin_banks	= exynos5433_pin_banks9,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks9),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+	},
+};
+
 /* pin banks of exynos7 pin-controller - ALIVE */
 static const struct samsung_pin_bank_data exynos7_pin_banks0[] __initconst = {
 	EXYNOS_PIN_BANK_EINTW(8, 0x000, "gpa0", 0x00),
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
index ec580af..ed165ba 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -1239,6 +1239,8 @@ static const struct of_device_id samsung_pinctrl_dt_match[] = {
 		.data = (void *)exynos5260_pin_ctrl },
 	{ .compatible = "samsung,exynos5420-pinctrl",
 		.data = (void *)exynos5420_pin_ctrl },
+	{ .compatible = "samsung,exynos5433-pinctrl",
+		.data = (void *)exynos5433_pin_ctrl },
 	{ .compatible = "samsung,s5pv210-pinctrl",
 		.data = (void *)s5pv210_pin_ctrl },
 	{ .compatible = "samsung,exynos7-pinctrl",
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.h b/drivers/pinctrl/samsung/pinctrl-samsung.h
index 1b8c013..c1239ff 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.h
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.h
@@ -271,6 +271,7 @@ extern const struct samsung_pin_ctrl exynos4415_pin_ctrl[];
 extern const struct samsung_pin_ctrl exynos5250_pin_ctrl[];
 extern const struct samsung_pin_ctrl exynos5260_pin_ctrl[];
 extern const struct samsung_pin_ctrl exynos5420_pin_ctrl[];
+extern const struct samsung_pin_ctrl exynos5433_pin_ctrl[];
 extern const struct samsung_pin_ctrl exynos7_pin_ctrl[];
 extern const struct samsung_pin_ctrl s3c64xx_pin_ctrl[];
 extern const struct samsung_pin_ctrl s3c2412_pin_ctrl[];
-- 
1.8.5.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaLBKTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:19:22 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:48465 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaLBKTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:19:15 -0500
X-AuditID: cbfee68e-f79b46d000002b74-8e-547d922095d4
From: Chanwoo Choi <cw00.choi@samsung.com>
To: tomasz.figa@gmail.com, thomas.abraham@linaro.org, linus.walleij@linaro.org
Cc: kgene.kim@samsung.com, inki.dae@samsung.com, geunsik.lim@samsung.com,
        kyungmin.park@samsung.com, pankaj.dubey@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2] pinctrl: exynos: Add support for Exynos5433
Date: Tue, 02 Dec 2014 19:19:11 +0900
Message-id: <1417515551-29981-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWyRsSkWFdhUm2IweoLmhbXvzxntfgzoZXN
	YtL9CSwWvQuuslmcbXrDbjHlz3Imi02Pr7FaXN41h81ixvl9TBaLtn5htzg2Ywmjxapdfxgd
	eDx2zrrL7nHn2h42j81L6j36tqxi9Pi8SS6ANYrLJiU1J7MstUjfLoEr48fpw0wFq90q7vY+
	Zm1g/GndxcjJISFgInH89lk2CFtM4sK99UA2F4eQwFJGiYbXd5lgii7OmcsOYgsJTGeU+L8v
	G6KoiUli+uUTYAk2AS2J/S9ugE0SEfCTeN/SwQpSxCwwgUliUfclVpCEsICdxM1Zx8Cmsgio
	Sjxesh7M5hVwlTh3uQFqm4LEsuUzwZolBBaxS/zY1McO0SAg8W3yIZYuRg6ghKzEpgPMEPWS
	EgdX3GCZwCi4gJFhFaNoakFyQXFSepGRXnFibnFpXrpecn7uJkZgoJ/+96xvB+PNA9aHGAU4
	GJV4eE+crwkRYk0sK67MPcRoCrRhIrOUaHI+MJ7ySuINjc2MLExNTI2NzC3NlMR5E6R+BgsJ
	pCeWpGanphakFsUXleakFh9iZOLglGpgVLGV3XeL31yDwdI/uCBSb/UVo79nLTbdE2ItfLW3
	7pyw+cttkszyEW5zJvjXvFz2oOrEqbmevytK7rKq9VVcii83qr6/eZNuxVve0x+FT7MJfzt4
	o6JsF1vESu6Oxk2vCjJPSsTW77V4sbf57kM1hU2c69h1ZrfMWHI1Wsvga883vZ27r69YqsRS
	nJFoqMVcVJwIAJxBEuRvAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t9jQV2FSbUhBsf+yltc//Kc1eLPhFY2
	i0n3J7BY9C64ymZxtukNu8WUP8uZLDY9vsZqcXnXHDaLGef3MVks2vqF3eLYjCWMFqt2/WF0
	4PHYOesuu8eda3vYPDYvqffo27KK0ePzJrkA1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4
	UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoPuUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqG
	BMH1GBmggYQ1jBk/Th9mKljtVnG39zFrA+NP6y5GTg4JAROJi3PmskPYYhIX7q1nA7GFBKYz
	Svzfl93FyAVkNzFJTL98AqyITUBLYv+LG2BFIgJ+Eu9bOlhBipgFJjBJLOq+xAqSEBawk7g5
	6xgTiM0ioCrxeMl6MJtXwFXi3OUGJohtChLLls9kncDIvYCRYRWjaGpBckFxUnquoV5xYm5x
	aV66XnJ+7iZGcBw9k9rBuLLB4hCjAAejEg/vifM1IUKsiWXFlbmHGCU4mJVEeH8Z14YI8aYk
	VlalFuXHF5XmpBYfYjQF2j6RWUo0OR8Y43kl8YbGJmZGlkbmhhZGxuZK4rw3buaGCAmkJ5ak
	ZqemFqQWwfQxcXBKNTAmHJ/8wDhkQt60SvttXQ9c+UwL/91Ief8g6MuEWy22txcLvmsxdHI6
	vV40x1peiS/huLBH3vb7Wf433u0Ne3jGzdi35rtL7pet3Sm7StWZdB2ZNK9rXtEyfKJSaviw
	8N7/vz98t4vxsK/+eNh8ZrZBd9mylpoUoNfrjcVb22683ZRst+uojBJLcUaioRZzUXEiAJTU
	c025AgAA
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
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
Changes from v1:
- Fix the wrong number of Exynos5433 (four -> ten)
- Divide pinctrl patch from following patch[1]
 [1] https://lkml.org/lkml/2014/12/2/134

 drivers/pinctrl/samsung/pinctrl-exynos.c  | 163 ++++++++++++++++++++++++++++++
 drivers/pinctrl/samsung/pinctrl-samsung.c |   2 +
 drivers/pinctrl/samsung/pinctrl-samsung.h |   1 +
 3 files changed, 166 insertions(+)

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index d5d4cfc..67da569 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -1240,6 +1240,169 @@ const struct samsung_pin_ctrl exynos5420_pin_ctrl[] __initconst = {
 	},
 };
 
+/* pin banks of exynos5433 pin-controller - ALIVE */
+static struct samsung_pin_bank exynos5433_pin_banks0[] = {
+	EXYNOS_PIN_BANK_EINTW(8, 0x000, "gpa0", 0x00),
+	EXYNOS_PIN_BANK_EINTW(8, 0x020, "gpa1", 0x04),
+	EXYNOS_PIN_BANK_EINTW(8, 0x040, "gpa2", 0x08),
+	EXYNOS_PIN_BANK_EINTW(8, 0x060, "gpa3", 0x0c),
+};
+
+/* pin banks of exynos5433 pin-controller - AUD */
+static struct samsung_pin_bank exynos5433_pin_banks1[] = {
+	EXYNOS_PIN_BANK_EINTG(7, 0x000, "gpz0", 0x00),
+	EXYNOS_PIN_BANK_EINTG(4, 0x020, "gpz1", 0x04),
+};
+
+/* pin banks of exynos5433 pin-controller - CPIF */
+static struct samsung_pin_bank exynos5433_pin_banks2[] = {
+	EXYNOS_PIN_BANK_EINTG(2, 0x000, "gpv6", 0x00),
+};
+
+/* pin banks of exynos5433 pin-controller - eSE */
+static struct samsung_pin_bank exynos5433_pin_banks3[] = {
+	EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj2", 0x00),
+};
+
+/* pin banks of exynos5433 pin-controller - FINGER */
+static struct samsung_pin_bank exynos5433_pin_banks4[] = {
+	EXYNOS_PIN_BANK_EINTG(4, 0x000, "gpd5", 0x00),
+};
+
+/* pin banks of exynos5433 pin-controller - FSYS */
+static struct samsung_pin_bank exynos5433_pin_banks5[] = {
+	EXYNOS_PIN_BANK_EINTG(6, 0x000, "gph1", 0x00),
+	EXYNOS_PIN_BANK_EINTG(7, 0x020, "gpr4", 0x04),
+	EXYNOS_PIN_BANK_EINTG(5, 0x040, "gpr0", 0x08),
+	EXYNOS_PIN_BANK_EINTG(8, 0x060, "gpr1", 0x0c),
+	EXYNOS_PIN_BANK_EINTG(2, 0x080, "gpr2", 0x10),
+	EXYNOS_PIN_BANK_EINTG(8, 0x0a0, "gpr3", 0x14),
+};
+
+/* pin banks of exynos5433 pin-controller - IMEM */
+static struct samsung_pin_bank exynos5433_pin_banks6[] = {
+	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpf0", 0x00),
+};
+
+/* pin banks of exynos5433 pin-controller - NFC */
+static struct samsung_pin_bank exynos5433_pin_banks7[] = {
+	EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj0", 0x00),
+};
+
+/* pin banks of exynos5433 pin-controller - PERIC */
+static struct samsung_pin_bank exynos5433_pin_banks8[] = {
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
+static struct samsung_pin_bank exynos5433_pin_banks9[] = {
+	EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj1", 0x00),
+};
+
+/*
+ * Samsung pinctrl driver data for Exynos5433 SoC. Exynos5433 SoC includes
+ * ten gpio/pin-mux/pinconfig controllers.
+ */
+struct samsung_pin_ctrl exynos5433_pin_ctrl[] = {
+	{
+		/* pin-controller instance 0 data */
+		.pin_banks	= exynos5433_pin_banks0,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks0),
+		.eint_wkup_init = exynos_eint_wkup_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5433-gpio-ctrl0",
+	}, {
+		/* pin-controller instance 1 data */
+		.pin_banks	= exynos5433_pin_banks1,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks1),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5433-gpio-ctrl1",
+	}, {
+		/* pin-controller instance 2 data */
+		.pin_banks	= exynos5433_pin_banks2,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks2),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5433-gpio-ctrl2",
+	}, {
+		/* pin-controller instance 3 data */
+		.pin_banks	= exynos5433_pin_banks3,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks3),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5433-gpio-ctrl3",
+	}, {
+		/* pin-controller instance 4 data */
+		.pin_banks	= exynos5433_pin_banks4,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks4),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5433-gpio-ctrl4",
+	}, {
+		/* pin-controller instance 5 data */
+		.pin_banks	= exynos5433_pin_banks5,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks5),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5433-gpio-ctrl5",
+	}, {
+		/* pin-controller instance 6 data */
+		.pin_banks	= exynos5433_pin_banks6,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks6),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5433-gpio-ctrl6",
+	}, {
+		/* pin-controller instance 7 data */
+		.pin_banks	= exynos5433_pin_banks7,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks7),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5433-gpio-ctrl7",
+	}, {
+		/* pin-controller instance 8 data */
+		.pin_banks	= exynos5433_pin_banks8,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks8),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5433-gpio-ctrl8",
+	}, {
+		/* pin-controller instance 9 data */
+		.pin_banks	= exynos5433_pin_banks9,
+		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks9),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos5433-gpio-ctrl9",
+	},
+};
+
 /* pin banks of exynos7 pin-controller - ALIVE */
 static const struct samsung_pin_bank_data exynos7_pin_banks0[] __initconst = {
 	EXYNOS_PIN_BANK_EINTW(8, 0x000, "gpa0", 0x00),
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
index 32940a0..26ac7a1 100644
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaJ0BVd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 21:21:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:18946 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaJ0BVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 21:21:31 -0400
X-AuditID: cbfee68f-f791c6d000004834-1e-544d9e147cc8
From: Chanwoo Choi <cw00.choi@samsung.com>
To: tomasz.figa@gmail.com, thomas.abraham@linaro.org, linus.walleij@linaro.org
Cc: kgene.kim@samsung.com, sw0312.kim@samsung.com, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2] pinctrl: exynos: Add support for Exynos4415
Date: Mon, 27 Oct 2014 10:21:18 +0900
Message-id: <1414372878-3737-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWyRsSkQFdknm+IwbEuVYvrX56zWvQuuMpm
	cbbpDbvFlD/LmSw2Pb7GanF51xw2ixnn9zFZzJj8ks3i2IwljBardv1hdODy2DnrLrvHnWt7
	2Dw2L6n36NuyitHj8ya5ANYoLpuU1JzMstQifbsEroy5s+eyFNzTq1g34xVrA+NqjS5GTg4J
	AROJWdP/MkPYYhIX7q1nA7GFBJYySqw4IAFT82HbdpYuRi6g+CJGiYntW1khipqYJP7+0QWx
	2QS0JPa/uAHWLCLgJ/G+pYMVpIFZ4C6jxJXu+SwgCWEBO4ntv18ygdgsAqoS1180g23mFXCR
	mH/vC9QVChLLls8Ea5YQmM4u8WrJfDaIBgGJb5MPAQ3iAErISmw6AFUvKXFwxQ2WCYyCCxgZ
	VjGKphYkFxQnpRcZ6xUn5haX5qXrJefnbmIEhvTpf8/6dzDePWB9iFGAg1GJh9ei0DdEiDWx
	rLgy9xCjKdCGicxSosn5wMjJK4k3NDYzsjA1MTU2Mrc0UxLnXSj1M1hIID2xJDU7NbUgtSi+
	qDQntfgQIxMHp1QD4+Qjt993KjjfTLmXPkHsg+FHHeltUy/mrlE4ktPtfj7bc8rRNr05bz9z
	RpiazhCfvM723DMJmxVmmqeftRbU7+Dv4uFYv3t/w9k9NiVm/VP3r/NySm+ZODu7Vi2P+9EG
	5hdvai4cqzDd77j1wIar22vXd+q9EPiy7umPV92bedOMLRfMZs4wfanEUpyRaKjFXFScCADo
	ZomQZAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsVy+t9jAV2Reb4hBv92S1pc//Kc1aJ3wVU2
	i7NNb9gtpvxZzmSx6fE1VovLu+awWcw4v4/JYsbkl2wWx2YsYbRYtesPowOXx85Zd9k97lzb
	w+axeUm9R9+WVYwenzfJBbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp
	5CXmptoqufgE6Lpl5gBdpaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM
	mDt7LkvBPb2KdTNesTYwrtboYuTkkBAwkfiwbTsLhC0mceHeerYuRi4OIYFFjBIT27eygiSE
	BJqYJP7+0QWx2QS0JPa/uMEGYosI+Em8b+lgBWlgFrjLKHGlez7YJGEBO4ntv18ygdgsAqoS
	1180M4PYvAIuEvPvfWGG2KYgsWz5TNYJjNwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+du
	YgTHzDOpHYwrGywOMQpwMCrx8FoU+oYIsSaWFVfmHmKU4GBWEuEVzQcK8aYkVlalFuXHF5Xm
	pBYfYjQF2j6RWUo0OR8Yz3kl8YbGJmZGlkbmhhZGxuZK4rwHWq0DhQTSE0tSs1NTC1KLYPqY
	ODilGhhnTLH0lz51Qusig/rbbwZlcWeVnY4e1mmfpxC9dEr+vhzrmqWnjp7pOxM7UfFEUdWk
	+RKszdlVM+cpvHI9ysaxjm2t5o7ECMUrXTfWqj2xCy6tMd9/wrPHdz5f7od9KWZ9uyyEdOvM
	KpXvJCs5ZL61V1y9e/rKFpVpj+fmVDFeMgw5EnlnzR0lluKMREMt5qLiRAD2bIborwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <tomasz.figa@gmail.com>

The pin controllers of Exynos4415 are similar to Exynos4412, but certain
differences cause the need to create separate driver data for it. This
patch adds pin controller and bank descriptor arrays to the driver to
support the new SoC.

Cc: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
[cw00.choi: Rebase it on mainline kernel]
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes from v1:
- Separate only pinctrl patch from Exynos4415 patchset[1]
 [1] [PATCH 0/5] Support new Exynos4415 SoC based on Cortex-A9 quad cores
  : https://lkml.org/lkml/2014/10/19/253

drivers/pinctrl/samsung/pinctrl-exynos.c  | 78 +++++++++++++++++++++++++++++++
 drivers/pinctrl/samsung/pinctrl-samsung.c |  2 +
 drivers/pinctrl/samsung/pinctrl-samsung.h |  1 +
 3 files changed, 81 insertions(+)

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index d7154ed..065eee0 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -920,6 +920,84 @@ struct samsung_pin_ctrl exynos4x12_pin_ctrl[] = {
 	},
 };
 
+/* pin banks of exynos4415 pin-controller 0 */
+static struct samsung_pin_bank exynos4415_pin_banks0[] = {
+	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
+	EXYNOS_PIN_BANK_EINTG(6, 0x020, "gpa1", 0x04),
+	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpb", 0x08),
+	EXYNOS_PIN_BANK_EINTG(5, 0x060, "gpc0", 0x0c),
+	EXYNOS_PIN_BANK_EINTG(5, 0x080, "gpc1", 0x10),
+	EXYNOS_PIN_BANK_EINTG(4, 0x0A0, "gpd0", 0x14),
+	EXYNOS_PIN_BANK_EINTG(4, 0x0C0, "gpd1", 0x18),
+	EXYNOS_PIN_BANK_EINTG(8, 0x180, "gpf0", 0x30),
+	EXYNOS_PIN_BANK_EINTG(8, 0x1A0, "gpf1", 0x34),
+	EXYNOS_PIN_BANK_EINTG(1, 0x1C0, "gpf2", 0x38),
+};
+
+/* pin banks of exynos4415 pin-controller 1 */
+static struct samsung_pin_bank exynos4415_pin_banks1[] = {
+	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpk0", 0x08),
+	EXYNOS_PIN_BANK_EINTG(7, 0x060, "gpk1", 0x0c),
+	EXYNOS_PIN_BANK_EINTG(7, 0x080, "gpk2", 0x10),
+	EXYNOS_PIN_BANK_EINTG(7, 0x0A0, "gpk3", 0x14),
+	EXYNOS_PIN_BANK_EINTG(4, 0x0C0, "gpl0", 0x18),
+	EXYNOS_PIN_BANK_EINTN(6, 0x120, "mp00"),
+	EXYNOS_PIN_BANK_EINTN(4, 0x140, "mp01"),
+	EXYNOS_PIN_BANK_EINTN(6, 0x160, "mp02"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x180, "mp03"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x1A0, "mp04"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x1C0, "mp05"),
+	EXYNOS_PIN_BANK_EINTN(8, 0x1E0, "mp06"),
+	EXYNOS_PIN_BANK_EINTG(8, 0x260, "gpm0", 0x24),
+	EXYNOS_PIN_BANK_EINTG(7, 0x280, "gpm1", 0x28),
+	EXYNOS_PIN_BANK_EINTG(5, 0x2A0, "gpm2", 0x2c),
+	EXYNOS_PIN_BANK_EINTG(8, 0x2C0, "gpm3", 0x30),
+	EXYNOS_PIN_BANK_EINTG(8, 0x2E0, "gpm4", 0x34),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC00, "gpx0", 0x00),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC20, "gpx1", 0x04),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC40, "gpx2", 0x08),
+	EXYNOS_PIN_BANK_EINTW(8, 0xC60, "gpx3", 0x0c),
+};
+
+/* pin banks of exynos4415 pin-controller 2 */
+static struct samsung_pin_bank exynos4415_pin_banks2[] = {
+	EXYNOS_PIN_BANK_EINTG(7, 0x000, "gpz", 0x00),
+	EXYNOS_PIN_BANK_EINTN(2, 0x000, "etc1"),
+};
+
+/*
+ * Samsung pinctrl driver data for Exynos4415 SoC. Exynos4415 SoC includes
+ * three gpio/pin-mux/pinconfig controllers.
+ */
+struct samsung_pin_ctrl exynos4415_pin_ctrl[] = {
+	{
+		/* pin-controller instance 0 data */
+		.pin_banks	= exynos4415_pin_banks0,
+		.nr_banks	= ARRAY_SIZE(exynos4415_pin_banks0),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos4415-gpio-ctrl0",
+	}, {
+		/* pin-controller instance 1 data */
+		.pin_banks	= exynos4415_pin_banks1,
+		.nr_banks	= ARRAY_SIZE(exynos4415_pin_banks1),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.eint_wkup_init = exynos_eint_wkup_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos4415-gpio-ctrl1",
+	}, {
+		/* pin-controller instance 2 data */
+		.pin_banks	= exynos4415_pin_banks2,
+		.nr_banks	= ARRAY_SIZE(exynos4415_pin_banks2),
+		.eint_gpio_init = exynos_eint_gpio_init,
+		.suspend	= exynos_pinctrl_suspend,
+		.resume		= exynos_pinctrl_resume,
+		.label		= "exynos4415-gpio-ctrl2",
+	},
+};
+
 /* pin banks of exynos5250 pin-controller 0 */
 static struct samsung_pin_bank exynos5250_pin_banks0[] = {
 	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
index 2d37c8f..d9b3e0c 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -1218,6 +1218,8 @@ static const struct of_device_id samsung_pinctrl_dt_match[] = {
 		.data = (void *)exynos4210_pin_ctrl },
 	{ .compatible = "samsung,exynos4x12-pinctrl",
 		.data = (void *)exynos4x12_pin_ctrl },
+	{ .compatible = "samsung,exynos4415-pinctrl",
+		.data = (void *)exynos4415_pin_ctrl },
 	{ .compatible = "samsung,exynos5250-pinctrl",
 		.data = (void *)exynos5250_pin_ctrl },
 	{ .compatible = "samsung,exynos5260-pinctrl",
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.h b/drivers/pinctrl/samsung/pinctrl-samsung.h
index 5cedc9d..10b720d 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.h
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.h
@@ -239,6 +239,7 @@ struct samsung_pmx_func {
 extern struct samsung_pin_ctrl exynos3250_pin_ctrl[];
 extern struct samsung_pin_ctrl exynos4210_pin_ctrl[];
 extern struct samsung_pin_ctrl exynos4x12_pin_ctrl[];
+extern struct samsung_pin_ctrl exynos4415_pin_ctrl[];
 extern struct samsung_pin_ctrl exynos5250_pin_ctrl[];
 extern struct samsung_pin_ctrl exynos5260_pin_ctrl[];
 extern struct samsung_pin_ctrl exynos5420_pin_ctrl[];
-- 
1.8.5.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaLJIrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:47:05 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:31582 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaLJIq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:46:59 -0500
X-AuditID: cbfee68e-f79b46d000002b74-34-548808810df1
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: robh+dt@kernel.org, kgene@kernel.org, alim.akhtar@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH V3 2/2] pinctrl: exynos: Add BUS1 pin controller for exynos7
Date: Wed, 10 Dec 2014 14:09:40 +0530
Message-id: <1418200780-22363-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 2.2.0
In-reply-to: <1418200780-22363-1-git-send-email-gautam.vivek@samsung.com>
References: <1418200780-22363-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsWyRsSkWreRoyPEoOOPmMWDedvYLOYfOcdq
	0XblILtF/+PXzBZT/ixnsri8aw6bxYzz+5gsFi1rZbZo3XuE3WLVrj+MDlweO2fdZffYtKqT
	zePOtT1sHn1bVjF6fN4kF8AaxWWTkpqTWZZapG+XwJWx7NE0toL7YhWNK7oYGxg3CncxcnJI
	CJhI3O07xAphi0lcuLeerYuRi0NIYCmjxPwnd5lhiuae/gNWJCSwiFHi5v4EiKIJTBIb35xn
	A0mwCehKNL3dxQhiiwjUSEy5dYUdpIhZYC+jxL1dECuEBXwkLra8YAKxWQRUJW4eOc0CYvMK
	eEis29gOtU1OYsutR+wgNqeAp8S1l0eB6jmAtnlIXJzvDTJTQmAbu8TKmd1sEHMEJL5NPsQC
	UiMhICux6QDUGEmJgytusExgFF7AyLCKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIzAKTv97
	1reD8eYB60OMAhyMSjy8AZfbQ4RYE8uKK3MPMZoCbZjILCWanA+MtbySeENjMyMLUxNTYyNz
	SzMlcd4EqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgVemXnRiRPnXCs6MXVaiXbVQpp
	C+VTfkurlauc/fNyDqdwkUN05f30pu5ZUTlKkTe2ZQvrfpW3rr3Xu9uZa13dvz8vjPMunnB7
	ePoLu+bEiSdcWoxqJxyIWLPws/f/nQaZ2uKL379g7tWwkZ9/JVBwXX6R4fK1ltdSIteGHNj3
	wuZa5P9AR1YlluKMREMt5qLiRAAlyynsfQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t9jAd1Gjo4Qg+N3eS0ezNvGZjH/yDlW
	i7YrB9kt+h+/ZraY8mc5k8XlXXPYLGac38dksWhZK7NF694j7Bardv1hdODy2DnrLrvHplWd
	bB53ru1h8+jbsorR4/MmuQDWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3Ml
	hbzE3FRbJRefAF23zBygs5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWM
	GcseTWMruC9W0biii7GBcaNwFyMnh4SAicTc039YIWwxiQv31rOB2EICixglbu5P6GLkArIn
	MElsfHMeLMEmoCvR9HYXI4gtIlAjMeXWFXaQImaBvYwS93YdApskLOAjcbHlBROIzSKgKnHz
	yGkWEJtXwENi3cZ2ZohtchJbbj1iB7E5BTwlrr08ClTPAbTNQ+LifO8JjLwLGBlWMYqmFiQX
	FCel5xrpFSfmFpfmpesl5+duYgTH2DPpHYyrGiwOMQpwMCrx8AZcbg8RYk0sK67MPcQowcGs
	JMK7nbUjRIg3JbGyKrUoP76oNCe1+BCjKdBRE5mlRJPzgfGfVxJvaGxibmpsamliYWJmqSTO
	q2TfFiIkkJ5YkpqdmlqQWgTTx8TBKdXA2J+0s8Amqj1hxf3/0QZL5U3VD+/6vHeC2dQbHm0x
	ou7TZ02KPei7Lvhwi93yXw9/df+WK2bn2f4vb0MM55vnE9VupzrKPuxwS55+aNlTjsKf9w7e
	nSq4Y5LsJf8tDz9/DtxmtZlB8d/SAL8DkxZf8hA9Mo/PQGNP1bItprKFNtxX/+ds0GBQmajE
	UpyRaKjFXFScCABfa7mYxwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB and Power regulator on Exynos7 require gpios available
in BUS1 pin controller block.
So adding the BUS1 pinctrl support.

Signed-off-by: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
---

Changes since V2:
 - Added documentation on alias for BUS1 pin controller block.

Changes since V1:
 - Added support for all pin banks which are part of BUS1 pin controller.

 .../devicetree/bindings/pinctrl/samsung-pinctrl.txt |    1 +
 drivers/pinctrl/samsung/pinctrl-exynos.c            |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
index 742e472..c88ba35 100644
--- a/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
@@ -180,6 +180,7 @@ Aliases for controllers compatible with "samsung,exynos7-pinctrl":
 - pinctrl5: pin controller of ESE block,
 - pinctrl6: pin controller of FSYS0 block,
 - pinctrl7: pin controller of FSYS1 block,
+- pinctrl8: pin controller of BUS1 block,
 
 Example: A pin-controller node with pin banks:
 
diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index d5d4cfc..44e60dc 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -1300,6 +1300,20 @@ static const struct samsung_pin_bank_data exynos7_pin_banks7[] __initconst = {
 	EXYNOS_PIN_BANK_EINTG(8, 0x060, "gpr3", 0x0c),
 };
 
+/* pin banks of exynos7 pin-controller - BUS1 */
+static const struct samsung_pin_bank_data exynos7_pin_banks8[] __initconst = {
+	EXYNOS_PIN_BANK_EINTG(8, 0x020, "gpf0", 0x00),
+	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpf1", 0x04),
+	EXYNOS_PIN_BANK_EINTG(4, 0x060, "gpf2", 0x08),
+	EXYNOS_PIN_BANK_EINTG(5, 0x080, "gpf3", 0x0c),
+	EXYNOS_PIN_BANK_EINTG(8, 0x0a0, "gpf4", 0x10),
+	EXYNOS_PIN_BANK_EINTG(8, 0x0c0, "gpf5", 0x14),
+	EXYNOS_PIN_BANK_EINTG(5, 0x0e0, "gpg1", 0x18),
+	EXYNOS_PIN_BANK_EINTG(5, 0x100, "gpg2", 0x1c),
+	EXYNOS_PIN_BANK_EINTG(6, 0x120, "gph1", 0x20),
+	EXYNOS_PIN_BANK_EINTG(3, 0x140, "gpv6", 0x24),
+};
+
 const struct samsung_pin_ctrl exynos7_pin_ctrl[] __initconst = {
 	{
 		/* pin-controller instance 0 Alive data */
@@ -1342,5 +1356,10 @@ const struct samsung_pin_ctrl exynos7_pin_ctrl[] __initconst = {
 		.pin_banks	= exynos7_pin_banks7,
 		.nr_banks	= ARRAY_SIZE(exynos7_pin_banks7),
 		.eint_gpio_init = exynos_eint_gpio_init,
+	}, {
+		/* pin-controller instance 8 BUS1 data */
+		.pin_banks	= exynos7_pin_banks8,
+		.nr_banks	= ARRAY_SIZE(exynos7_pin_banks8),
+		.eint_gpio_init = exynos_eint_gpio_init,
 	},
 };
-- 
1.7.10.4


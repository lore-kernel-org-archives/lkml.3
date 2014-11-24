Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaKXNKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:10:07 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:13253 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaKXNKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:10:03 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-8c-54732e287a8a
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: tomasz.figa@gmail.com, s.nawrocki@samsung.com, robh+dt@kernel.org,
        kgene@kernel.org, alim.akhtar@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH V2 1/2] pinctrl: exynos: Add BUS1 pin controller for exynos7
Date: Mon, 24 Nov 2014 18:32:57 +0530
Message-id: <1416834177-11170-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <CAFp+6iF-N63YSsdv2a6=MYp_mD=eQY_Oi8=9JVNU5dG0BA7YGQ@mail.gmail.com>
References: <CAFp+6iF-N63YSsdv2a6=MYp_mD=eQY_Oi8=9JVNU5dG0BA7YGQ@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWyRsSkVldDrzjE4MpHC4sH87axWcw/co7V
	ou3KQXaL/sevmS2m/FnOZHF51xw2ixnn9zFZLFrWymzRuvcIu8XhN+2sFqt2/WF04PbYOesu
	u8emVZ1sHneu7WHz6NuyitHj8ya5ANYoLpuU1JzMstQifbsErowr32cyFcwWrFix9ylLA+MF
	vi5GTg4JAROJlVdb2SFsMYkL99azdTFycQgJLGWUmLPyLCNM0bbFB6ES0xkl2na8ZIJwJjBJ
	XJvewQJSxSagK9H0dhdYh4hAjcSUW1fYQYqYBU4ySnw+voQNJCEs4CNx5MoKMJtFQFXiYutC
	sAZeAQ+J9gPngBo4gNYpSMyZZAMS5hQIltj1t5UZxBYSCJD42nqSGWSmhMAudolf209AzRGQ
	+Db5EAtEr6zEpgPMEFdLShxccYNlAqPwAkaGVYyiqQXJBcVJ6UUmesWJucWleel6yfm5mxiB
	EXH637MJOxjvHbA+xCjAwajEw/thY1GIEGtiWXFl7iFGU6ANE5mlRJPzgXGXVxJvaGxmZGFq
	YmpsZG5ppiTO+1rqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRjcReQPrsv8HPj1pF/wl
	IGp+KKbIWOGv7txZqy9t1nFwNNq9LuipTuTX0z3c/TUVq0sFvpRpCLz/ffV94+zQ6xMOd67n
	fiG9JutdsYps6U5Xnru7isrNtwp2yDzad2rpZ5WPqRarHz+rWSX9xrZoYY/Bscnvrq01i3u4
	/MNFo2VT+aw+30/dlqTEUpyRaKjFXFScCAA1SPNogwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jQV0NveIQg13/9CwezNvGZjH/yDlW
	i7YrB9kt+h+/ZraY8mc5k8XlXXPYLGac38dksWhZK7NF694j7BaH37SzWqza9YfRgdtj56y7
	7B6bVnWyedy5tofNo2/LKkaPz5vkAlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1
	DS0tzJUU8hJzU22VXHwCdN0yc4BuU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12Nk
	gAYS1jBmXPk+k6lgtmDFir1PWRoYL/B1MXJySAiYSGxbfJANwhaTuHBvPZDNxSEkMJ1Rom3H
	SyYIZwKTxLXpHSwgVWwCuhJNb3cxgtgiAjUSU25dYQcpYhY4ySjx+fgSsFHCAj4SR66sALNZ
	BFQlLrYuBGvgFfCQaD9wDqiBA2idgsScSTYgYU6BYIldf1uZQWwhgQCJr60nmScw8i5gZFjF
	KJpakFxQnJSea6RXnJhbXJqXrpecn7uJERxvz6R3MK5qsDjEKMDBqMTDO2N9UYgQa2JZcWXu
	IUYJDmYlEV4xseIQId6UxMqq1KL8+KLSnNTiQ4ymQEdNZJYSTc4HpoK8knhDYxNzU2NTSxML
	EzNLJXHeGzdzQ4QE0hNLUrNTUwtSi2D6mDg4pRoYtRw5Pm6W5ag1TuYNuhj0+HP9pbUSX/8G
	dX+oYu1PmWQ7Y36o+DLt1IQH5/9ciu/8Uftebh93So/NfPFJ85Z9DumdUe5rdPaV6KNPRrby
	110+ZB+65jf1uMjrYwVNsY4nAhtWFr5tWXJT5JDxfJVMyfM7p64IY66/fcvwn1/UkubgxFtF
	DUdOKbEUZyQaajEXFScCAEBbW77NAgAA
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
Cc: Linus Walleij <linus.walleij@linaro.org>
---

This patch was part of series:
"[PATCH 00/11] Exynos7: Adding USB 3.0 support"
 https://lkml.org/lkml/2014/11/21/247

Changes since V1:
 - Added support for all pin banks which are part of BUS1 pin controller.

 drivers/pinctrl/samsung/pinctrl-exynos.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

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


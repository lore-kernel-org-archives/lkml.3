Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaJTDdn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 23:33:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34105 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaJTDci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 23:32:38 -0400
X-AuditID: cbfee68f-f791c6d000004834-b2-5444825138d8
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, ben-linux@fluff.org, linux@arm.linux.org.uk,
        mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        tomasz.figa@gmail.com, mturquette@linaro.org,
        thomas.abraham@linaro.org, linus.walleij@linaro.org,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com,
        inki.dae@samsung.com, geunsik.lim@samsung.com, jh80.chung@samsung.com,
        cw00.choi@samsung.com, jaewon02.kim@samsung.com,
        ideal.song@samsung.com, yj44.cho@samsung.com
Subject: [PATCH 4/5] pinctrl: exynos: Add support for Exynos4415
Date: Mon, 20 Oct 2014 12:32:14 +0900
Message-id: <1413775935-17743-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>
References: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsWyRsSkQDewySXE4ESTkcXfScfYLSatO8Bk
	cf3Lc1aLPxNa2Sx2/b3PaDHp/gQWix0NR1gtbvxqY7XoXXCVzeJs0xt2iyl/ljNZbHp8jdXi
	8q45bBYzzu9jsrh9mddi6fWLTBZPJ1xkszh1/TNQfPJLNotjM5YwWqza9YfRYu/OyYwOYh5r
	5q1h9Ghp7mHz+P1rEqPH31UvmD12zrrL7nHn2h42j81L6j2unGhi9ejbsorR4/MmuQCuKC6b
	lNSczLLUIn27BK6MKwvWMRfM1K3Yfm0BUwNju3oXIweHhICJxOm2hC5GTiBTTOLCvfVsXYxc
	HEICSxklVrzczgiRMJF4PucmE0RiOqPE3aXzoaqamCQ2d79hBqliE9CS2P/iBhuILSKQLXGl
	8T4zSBGzwEFmiY+fethBEsICDhKHZu8AK2IRUJV4tK0BbAWvgKvE7B8T2CHWyUl82PMIzOYU
	cJM43PWfCeRUIaCaGZtVQWZKCKzkkLjfMJ0ZYo6AxLfJh1gg3pGV2HSAGWKMpMTBFTdYJjAK
	L2BkWMUomlqQXFCclF5krFecmFtcmpeul5yfu4kRGKun/z3r38F494D1IUYBDkYlHt4dZi4h
	QqyJZcWVuYcYTYE2TGSWEk3OByaEvJJ4Q2MzIwtTE1NjI3NLMyVx3oVSP4OFBNITS1KzU1ML
	Uovii0pzUosPMTJxcEo1MEZc2aP26P09pgZrp2OTndf/fhWtIt0qXPHB+O8hsUuM3hUWp//V
	CUjs/e2VfT7RWfeSzuMo5wNLXtTdflgWpPLob9mdMMWHmh3KvwqM13Ymfv3wa/pW3pc7lDey
	F5hkB087ndkkv9Fld4yL1bMihaLi7ubVUcUiT43Z/k2xDfpczl6rc+C0hBJLcUaioRZzUXEi
	ALt0qprQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xoG5gk0uIQdsCFYu/k46xW0xad4DJ
	4vqX56wWfya0slns+nuf0WLS/QksFjsajrBa3PjVxmrRu+Aqm8XZpjfsFlP+LGey2PT4GqvF
	5V1z2CxmnN/HZHH7Mq/F0usXmSyeTrjIZnHq+meg+OSXbBbHZixhtFi16w+jxd6dkxkdxDzW
	zFvD6NHS3MPm8fvXJEaPv6teMHvsnHWX3ePOtT1sHpuX1HtcOdHE6tG3ZRWjx+dNcgFcUQ2M
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAnyoplCXm
	lAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM64sWMdcMFO3Yvu1BUwNjO3qXYyc
	HBICJhLP59xkgrDFJC7cW8/WxcjFISQwnVHi7tL5UE4Tk8Tm7jfMIFVsAloS+1/cYAOxRQSy
	Ja403mcGKWIWOMgs8fFTDztIQljAQeLQ7B1gRSwCqhKPtjUwgti8Aq4Ss39MYIdYJyfxYc8j
	MJtTwE3icNd/oDM4gLa5SszYrDqBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOBU
	8Ex6B+OqBotDjAIcjEo8vDvMXEKEWBPLiitzDzFKcDArifD+ywAK8aYkVlalFuXHF5XmpBYf
	YjQFOmois5Rocj4wTeWVxBsam5gZWRqZG1oYGZsrifMebLUOFBJITyxJzU5NLUgtgulj4uCU
	amBcETrZKVoqXOXESsdnKi+PRUgd/Bn0S8xVfIPSry+i2Vk+5ox2p8Ic3mc2TvhWxuW5wCxd
	qJKjnHNKu9qCQy7Hzae8FNxinqlXFLzNeuq7TgWLpdWvds5c56jeWyLVzSVUqORXYt6ceUt/
	+v8TbrKNitu59YIna26aV3Zt/r9Hbt/3SE5VjVdiKc5INNRiLipOBADiokcuGwMAAA==
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
index b07406d..0397ce5 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -1224,6 +1224,8 @@ static const struct of_device_id samsung_pinctrl_dt_match[] = {
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
1.8.0


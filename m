Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab3CKD6p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 23:58:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30302 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3CKD6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 23:58:44 -0400
X-AuditID: cbfee690-b7f656d0000007e3-2f-513d56716e6b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: l4f00242t03: check return value of
 regulator_enable()
Date: Mon, 11 Mar 2013 12:58:41 +0900
Message-id: <005f01ce1e0c$b7dbcfc0$27936f40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4eDLe8BOOG3YaaQN2mW67zG6BGFQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t8zQ93CMNtAg60L9Cwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG3nWvmQve8VZsfXyevYHxJncXIyeHhICJxOybzYwQtpjEhXvr
	2boYuTiEBJYxSrx8v4gNpujxlTZmiMQiRonGRzPYIZzZTBKvO06wgFSxCahJfPlyGCjBwSEi
	oC/R1qIBEmYWKJXY+uA9WImwQLDEk5fTmUFKWARUJfY3pIKEeQVsJdbM+MMCYQtK/Jh8jwWi
	VUti87YmVghbXmLzmrdgrRIC6hKP/uqChEUE9CSutG9jgygRkdj34h0jyGUSAu3sEvsmtzOB
	JFgEBCS+TT7EAtErK7HpADPEW5ISB1fcYJnAKDYLyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQn
	pReZ6BUn5haX5qXrJefnbmKExMmEHYz3DlgfYkwGWj+RWUo0OR8YZ3kl8YbGZkYWpiamxkbm
	lmakCSuJ86q3WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYIyd0P77zUSelbf3L1jyMvL9
	zbcSVZNE7nJGzzphf7faYXejSFX1sz42nxXc7VH/p0x1XihzYe3Cn11hx9SK+QV1kz+/Zlkj
	WsDFUx82xWttI+dRJ42Zgv9qXZeXnTMK8fSZl2mWpSBhIGsfGfdkk9x8GYFJsz+/4IxlcVJX
	VDOI/210fOIbSyWW4oxEQy3mouJEAHTo7/apAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jAd3CMNtAg0P9WhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY++618wF73grtj4+z97A
	eJO7i5GTQ0LAROLxlTZmCFtM4sK99WxdjFwcQgKLGCUaH81gh3BmM0m87jjBAlLFJqAm8eXL
	YaAEB4eIgL5EW4sGSJhZoFRi64P3YCXCAsEST15OZwYpYRFQldjfkAoS5hWwlVgz4w8LhC0o
	8WPyPRaIVi2JzduaWCFseYnNa96CtUoIqEs8+qsLEhYR0JO40r6NDaJERGLfi3eMExgFZiGZ
	NAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnAUPpPewbiqweIQowAH
	oxIP7wQd20Ah1sSy4srcQ4wSHMxKIrwrN9kECvGmJFZWpRblxxeV5qQWH2JMBvpzIrOUaHI+
	MEHklcQbGpuYGVkamVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAOjffm8oA2T
	3ppJPUq3F6yv5cr/4PreXfK3+f89fztlGme/c9h1c75D83L1Vb75Bqu9rc6FH204PTk3fylD
	4VbWni8BbclddZPlg+w051nofoqy3B2wpZzzVcCM0lmG2gtne9uXF927+ObMRrkFjf3OZfOu
	FngbTzusF+Jj12qmf9XKkFNx8zQlluKMREMt5qLiRAB4HZy/BgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator_enable() was marked as as __must_check, therefore,
the return value of regulator_enable() should be checked.
Also, this patch checks return value of regulator_set_voltage().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/l4f00242t03.c |   27 ++++++++++++++++++++++-----
 1 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
index fb61557..8d54c3c 100644
--- a/drivers/video/backlight/l4f00242t03.c
+++ b/drivers/video/backlight/l4f00242t03.c
@@ -51,14 +51,31 @@ static void l4f00242t03_lcd_init(struct spi_device *spi)
 	struct l4f00242t03_pdata *pdata = spi->dev.platform_data;
 	struct l4f00242t03_priv *priv = spi_get_drvdata(spi);
 	const u16 cmd[] = { 0x36, param(0), 0x3A, param(0x60) };
+	int ret;
 
 	dev_dbg(&spi->dev, "initializing LCD\n");
 
-	regulator_set_voltage(priv->io_reg, 1800000, 1800000);
-	regulator_enable(priv->io_reg);
+	ret = regulator_set_voltage(priv->io_reg, 1800000, 1800000);
+	if (ret) {
+		dev_err(&spi->dev, "failed to set the IO regulator voltage.\n");
+		return;
+	}
+	ret = regulator_enable(priv->io_reg);
+	if (ret) {
+		dev_err(&spi->dev, "failed to enable the IO regulator.\n");
+		return;
+	}
 
-	regulator_set_voltage(priv->core_reg, 2800000, 2800000);
-	regulator_enable(priv->core_reg);
+	ret = regulator_set_voltage(priv->core_reg, 2800000, 2800000);
+	if (ret) {
+		dev_err(&spi->dev, "failed to set the core regulator voltage.\n");
+		return;
+	}
+	ret = regulator_enable(priv->core_reg);
+	if (ret) {
+		dev_err(&spi->dev, "failed to enable the core regulator.\n");
+		return;
+	}
 
 	l4f00242t03_reset(pdata->reset_gpio);
 
-- 
1.7.2.5



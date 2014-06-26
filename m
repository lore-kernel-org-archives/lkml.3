Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaFZFSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 01:18:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50418 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaFZFSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 01:18:04 -0400
X-AuditID: cbfee690-b7fb56d000003439-18-53abad09b72e
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, linux-arm-kernel@lists.infradead.org,
        sjg@chromium.org, linux-kernel@vger.kernel.org, wsa@the-dreams.de,
        cpgs@samsung.com, broonie@kernel.org
Subject: [PATCH 1/2 v2] i2c: exynos5: remove an unnecessary read of FIFO_STATUS
 register
Date: Thu, 26 Jun 2014 10:44:57 +0530
Message-id: <1403759698-15624-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWyRsSkWpdz7epgg7adMhZTHz5hs3h5SNNi
	0+NrrBYdf78wWlzeNYfNYsb5fUwWi7b9Z7b4tmUbo8XKE7OYHTg9ZjdcZPHYOesuu8emVZ1s
	HpuX1Hv0bVnF6HHy1BMWj8+b5ALYo7hsUlJzMstSi/TtErgy7k14y1jwkK1i27SDTA2MV1i7
	GDk5JARMJJ5OPwJli0lcuLeerYuRi0NIYCmjxPw794ESHGBFW2/VQsSnM0rsfriIEcLpZ5Jo
	vn2RGaSbTcBM4uCi1ewgtoiAg8S8td/ZQYqYBTYySuxZfgFshbBAlMSXj0tZQGwWAVWJgw+f
	gDXwCrhKbLrfxgixTUFiziQbkF4JgUXsEnvW3IaqF5D4NvkQC0SNrMSmA8wQV0tKHFxxg2UC
	o+ACRoZVjKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGIGhffrfswk7GO8dsD7EmAw0biKzlGhy
	PjA28kriDY3NjCxMTUyNjcwtzUgTVhLnVXuUFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	UXd7cNXCpVN3lAV6zIg3NVKtfSPqqruyq6xy3soL8cuqTLear76T78Swb6vV/80H4w4vdZs+
	adGFtyE7tnIKya/bvXmRQMFXvutBS/ff2dWRIPfsSy4n06EbRpsvG9bOe/bVODw6S8moussi
	4U3Lx6NG3seqpzBsLL74/pfbxudXUrfGPk2b/1SJpTgj0VCLuag4EQBsCa/TgwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jQV3OtauDDc7cErWY+vAJm8XLQ5oW
	mx5fY7Xo+PuF0eLyrjlsFjPO72OyWLTtP7PFty3bGC1WnpjF7MDpMbvhIovHzll32T02repk
	89i8pN6jb8sqRo+Tp56weHzeJBfAHtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGto
	aWGupJCXmJtqq+TiE6DrlpkDdJmSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0
	kLCGMePehLeMBQ/ZKrZNO8jUwHiFtYuRg0NCwERi663aLkZOIFNM4sK99WxdjFwcQgLTGSV2
	P1zECOH0M0k0377IDFLFJmAmcXDRanYQW0TAQWLe2u/sIEXMAhsZJfYsv8AKkhAWiJL48nEp
	C4jNIqAqcfDhE7AGXgFXiU332xghNitIzJlkM4GRewEjwypG0dSC5ILipPRcI73ixNzi0rx0
	veT83E2M4Mh5Jr2DcVWDxSFGAQ5GJR7eD49XBQuxJpYVV+YeYpTgYFYS4X3/FyjEm5JYWZVa
	lB9fVJqTWnyI0RRo+URmKdHkfGBU55XEGxqbmJsam1qaWJiYWSqJ8x5stQ4UEkhPLEnNTk0t
	SC2C6WPi4JRqYDRYOetcs8eZhw9Oyh3/YyrSMCnt9fmwxK5pie8Vgvbslcq6++W0aq1jdcI5
	9//Zyz88N95wkmfCuiMmQlH2mxMrGGssJ/z59urB1FCfh9Nv+m3k1J609V573bLj1yxmuRav
	mDrJ5ot+Vp74hVKner6fSsXsZy1Kuvol5O/sqsmtn/mSrVLp+wwlluKMREMt5qLiRADwrSf+
	sgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes an extra read of FIFO_STATUS register in the interrrupt
service routine. Which is read again before the actual use.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v1:
None

 drivers/i2c/busses/i2c-exynos5.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index 63d2292..0d1a7bc 100644
--- a/drivers/i2c/busses/i2c-exynos5.c
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -405,7 +405,6 @@ static irqreturn_t exynos5_i2c_irq(int irqno, void *dev_id)
 
 	int_status = readl(i2c->regs + HSI2C_INT_STATUS);
 	writel(int_status, i2c->regs + HSI2C_INT_STATUS);
-	fifo_status = readl(i2c->regs + HSI2C_FIFO_STATUS);
 
 	/* handle interrupt related to the transfer status */
 	if (int_status & HSI2C_INT_I2C) {
-- 
1.7.9.5


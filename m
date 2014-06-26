Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaFZFSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 01:18:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50418 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaFZFSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 01:18:06 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-5e-53abad0a88cf
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, linux-arm-kernel@lists.infradead.org,
        sjg@chromium.org, linux-kernel@vger.kernel.org, wsa@the-dreams.de,
        cpgs@samsung.com, broonie@kernel.org
Subject: [PATCH 2/2 v2] i2c: exynos5: remove extra line and fix an assignment
Date: Thu, 26 Jun 2014 10:44:58 +0530
Message-id: <1403759698-15624-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1403759698-15624-1-git-send-email-ch.naveen@samsung.com>
References: <1403759698-15624-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSp8u1dnWwwasuK4upD5+wWbw8pGmx
	6fE1VouOv18YLS7vmsNmMeP8PiaLRdv+M1t827KN0WLliVnMDpwesxsusnjsnHWX3WPTqk42
	j81L6j36tqxi9Dh56gmLx+dNcgHsUVw2Kak5mWWpRfp2CVwZP6Z5FjRxVzTNPcvYwNjE2cXI
	ySEhYCLRPvEPM4QtJnHh3nq2LkYuDiGBpYwSD6bdYoIpWjznCCNEYjqjxMnPO5ghnH4miXk7
	2thBqtgEzCQOLloNZosIOEjMW/udHaSIWWAjo8Se5RdYuxg5OIQFfCVez8kCqWERUJX4d+wm
	2GpeAVeJO41XwUokBBQk5kyyAQlzCrhJPO36DjZSCKhk2qMdrCAjJQS2sUs8nPOQHWKOgMS3
	yYdYIHplJTYdgPpGUuLgihssExiFFzAyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQIjITT
	/5717WC8ecD6EGMy0LiJzFKiyfnASMoriTc0NjOyMDUxNTYytzQjTVhJnHfRw6QgIYH0xJLU
	7NTUgtSi+KLSnNTiQ4xMHJxSDYwqYdPefA8pdD/570X47ZW3Qv5Ip3CsCBDz2rPE6brFrvqt
	1jNDVzEsuh4RdXfDpJ4PcR+iLOYU/NRgCdK0cxX6ftD3WsS93Wwr+G/4rj5+uX3HpzWVkuY1
	SSH/vLYIHz/+UeGFVbB+1pfNCQJ+HyrZeON8nKWtj3nd339AZPXq7EN2ddt3HI9VYinOSDTU
	Yi4qTgQA/yArUJoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t9jQV2utauDDfa9NbSY+vAJm8XLQ5oW
	mx5fY7Xo+PuF0eLyrjlsFjPO72OyWLTtP7PFty3bGC1WnpjF7MDpMbvhIovHzll32T02repk
	89i8pN6jb8sqRo+Tp56weHzeJBfAHtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGto
	aWGupJCXmJtqq+TiE6DrlpkDdJmSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0
	kLCGMePHNM+CJu6KprlnGRsYmzi7GDk5JARMJBbPOcIIYYtJXLi3nq2LkYtDSGA6o8TJzzuY
	IZx+Jol5O9rYQarYBMwkDi5aDWaLCDhIzFv7nR2kiFlgI6PEnuUXWLsYOTiEBXwlXs/JAqlh
	EVCV+HfsJjOIzSvgKnGn8SpYiYSAgsScSTYgYU4BN4mnXd/BRgoBlUx7tIN1AiPvAkaGVYyi
	qQXJBcVJ6bmGesWJucWleel6yfm5mxjBcfZMagfjygaLQ4wCHIxKPLwfHq8KFmJNLCuuzD3E
	KMHBrCTC+/4vUIg3JbGyKrUoP76oNCe1+BCjKdBRE5mlRJPzgSkgryTe0NjE3NTY1NLEwsTM
	Ukmc90CrdaCQQHpiSWp2ampBahFMHxMHp1QD4xSXaSe2nxG7nvf8Qf30XrVDbKrXFpdn5L1X
	XHR/0V1Xf9tfq9k1diXfjTApWOj5RjTUr/e3c5iWpR6L18KQJU9E01j0C3VZVYtYWw99vbo9
	JPTx9+u7Wwxkej5Ozxf7t6NJw05IpXvqnqmVZTdOrftcp8DotCDuzQIOh8ksi77nnNkhq23p
	o8RSnJFoqMVcVJwIAEYE89PJAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does the following in exynos5_i2c_message_start() function
1. Fixes an assignment
   As, "i2c_auto_conf" is initialized to '0' at the beginning of the
   function and HSI2C_READ_WRITE is defined as (1u << 16)

   Using "|=" for the first assignment is more readable.

2. Removes an extra line 

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v1:
Edited commit message for clarity

 drivers/i2c/busses/i2c-exynos5.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index 0d1a7bc..4c2e6f3 100644
--- a/drivers/i2c/busses/i2c-exynos5.c
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -525,7 +525,7 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
 	if (i2c->msg->flags & I2C_M_RD) {
 		i2c_ctl |= HSI2C_RXCHON;
 
-		i2c_auto_conf = HSI2C_READ_WRITE;
+		i2c_auto_conf |= HSI2C_READ_WRITE;
 
 		trig_lvl = (i2c->msg->len > i2c->variant->fifo_depth) ?
 			(i2c->variant->fifo_depth * 3 / 4) : i2c->msg->len;
@@ -548,7 +548,6 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
 	writel(fifo_ctl, i2c->regs + HSI2C_FIFO_CTL);
 	writel(i2c_ctl, i2c->regs + HSI2C_CTL);
 
-
 	/*
 	 * Enable interrupts before starting the transfer so that we don't
 	 * miss any INT_I2C interrupts.
-- 
1.7.9.5


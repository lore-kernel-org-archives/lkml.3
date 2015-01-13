Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbbAMPKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:10:04 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50255 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbbAMPKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:10:01 -0500
From: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
To: linus.walleij@linaro.org, gnurou@gmail.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
Subject: [PATCH] gpio: gpio-dln2: Added a Blank line after declaration
Date: Tue, 13 Jan 2015 20:39:38 +0530
Message-Id: <1421161778-5671-1-git-send-email-md.jamalmohiuddin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the coding style issue by adding a blank line after declaration

Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
---
 drivers/gpio/gpio-dln2.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-dln2.c b/drivers/gpio/gpio-dln2.c
index ce3c155..dbdb4de 100644
--- a/drivers/gpio/gpio-dln2.c
+++ b/drivers/gpio/gpio-dln2.c
@@ -396,6 +396,7 @@ static void dln2_gpio_event(struct platform_device *pdev, u16 echo,
 			    const void *data, int len)
 {
 	int pin, irq;
+
 	const struct {
 		__le16 count;
 		__u8 type;
-- 
1.7.9.5


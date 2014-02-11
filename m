Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaBKQ05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:26:57 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:54577 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaBKQ0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:26:54 -0500
From: Richard Genoud <richard.genoud@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] trivial: gpiolib: typo in gpiochip_is_requested comment
Date: Tue, 11 Feb 2014 17:26:41 +0100
Message-Id: <1392136001-913-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/gpio/gpiolib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 80da9f1940c9..a0b96695c519 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1646,7 +1646,7 @@ void gpio_free_array(const struct gpio *array, size_t num)
 EXPORT_SYMBOL_GPL(gpio_free_array);
 
 /**
- * gpiochip_is_requested - return string iff signal was requested
+ * gpiochip_is_requested - return string if signal was requested
  * @chip: controller managing the signal
  * @offset: of signal within controller's 0..(ngpio - 1) range
  *
-- 
1.8.5


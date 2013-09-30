Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab3I3JB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 05:01:57 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:63311 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab3I3JBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 05:01:53 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: giometti@enneenne.com, akpm@linux-foundation.org, sachin.kamat@linaro.org
Subject: [PATCH 1/1] drivers/pps/clients/pps-gpio.c: Remove redundant of_match_ptr
Date: Mon, 30 Sep 2013 14:31:40 +0530
Message-Id: <1380531700-17751-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data structure of_match_ptr() protects is always compiled in.
Hence of_match_ptr() is not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pps/clients/pps-gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pps/clients/pps-gpio.c b/drivers/pps/clients/pps-gpio.c
index 9966124..f41bacf 100644
--- a/drivers/pps/clients/pps-gpio.c
+++ b/drivers/pps/clients/pps-gpio.c
@@ -201,7 +201,7 @@ static struct platform_driver pps_gpio_driver = {
 	.driver		= {
 		.name	= PPS_GPIO_NAME,
 		.owner	= THIS_MODULE,
-		.of_match_table	= of_match_ptr(pps_gpio_dt_ids),
+		.of_match_table	= pps_gpio_dt_ids,
 	},
 };
 
-- 
1.7.9.5


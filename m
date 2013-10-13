Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab3JMX1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 19:27:35 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:44337 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab3JMX1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 19:27:33 -0400
From: Roel Kluin <roel.kluin@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] unset twsi option3 for gconfig as well
Date: Mon, 14 Oct 2013 01:27:27 +0200
Message-Id: <1381706847-32762-1-git-send-email-roel.kluin@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/pinctrl/mvebu/pinctrl-dove.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 29f7e4f..360b9b2 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -335,7 +335,7 @@ static int dove_twsi_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 	unsigned long gcfg2 = readl(DOVE_GLOBAL_CONFIG_2);
 
 	gcfg1 &= ~DOVE_TWSI_ENABLE_OPTION1;
-	gcfg2 &= ~(DOVE_TWSI_ENABLE_OPTION2 | DOVE_TWSI_ENABLE_OPTION2);
+	gcfg2 &= ~(DOVE_TWSI_ENABLE_OPTION2 | DOVE_TWSI_ENABLE_OPTION3);
 
 	switch (config) {
 	case 1:
-- 
1.8.1.2


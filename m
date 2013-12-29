Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab3L2V5L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 16:57:11 -0500
Received: from 82-169-213-70.ip.telfort.nl ([82.169.213.70]:45290 "EHLO
	helium.area128.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753360Ab3L2V5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 16:57:09 -0500
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Dec 2013 16:57:09 EST
From: Antonios Vamporakis <ant@area128.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Antonios Vamporakis <ant@area128.com>,
        John Crispin <blogic@openwrt.org>
Subject: [PATCH] pinctrl/lantiq: fix typo
Date: Sun, 29 Dec 2013 22:48:02 +0100
Message-Id: <1388353682-19065-1-git-send-email-ant@area128.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Antonios Vamporakis <ant@area128.com>
CC: John Crispin <blogic@openwrt.org>
---
 drivers/pinctrl/pinctrl-xway.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-xway.c b/drivers/pinctrl/pinctrl-xway.c
index ed2d1ba..e66f4ca 100644
--- a/drivers/pinctrl/pinctrl-xway.c
+++ b/drivers/pinctrl/pinctrl-xway.c
@@ -332,10 +332,10 @@ static const struct ltq_pin_group xway_grps[] = {
 	GRP_MUX("mdio", MDIO, pins_mdio),
 	GRP_MUX("gphy0 led0", GPHY, pins_gphy0_led0),
 	GRP_MUX("gphy0 led1", GPHY, pins_gphy0_led1),
-	GRP_MUX("gphy0 lde2", GPHY, pins_gphy0_led2),
+	GRP_MUX("gphy0 led2", GPHY, pins_gphy0_led2),
 	GRP_MUX("gphy1 led0", GPHY, pins_gphy1_led0),
 	GRP_MUX("gphy1 led1", GPHY, pins_gphy1_led1),
-	GRP_MUX("gphy1 lde2", GPHY, pins_gphy1_led2),
+	GRP_MUX("gphy1 led2", GPHY, pins_gphy1_led2),
 };
 
 static const struct ltq_pin_group ase_grps[] = {
-- 
1.8.3.2


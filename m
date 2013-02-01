Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab3BAMJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 07:09:29 -0500
Received: from nbd.name ([46.4.11.11]:41396 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756632Ab3BAMH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 07:07:59 -0500
From: John Crispin <blogic@openwrt.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, John Crispin <blogic@openwrt.org>,
        Thomas Langer <thomas.langer@lantiq.com>
Subject: [PATCH 07/11] PINCTRL: lantiq: one of the boot leds was defined incorrectly
Date: Fri,  1 Feb 2013 13:05:01 +0100
Message-Id: <1359720305-31933-7-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the Falcon SoC the bootleds are located on pins 9->14.

Signed-off-by: Thomas Langer <thomas.langer@lantiq.com>
Signed-off-by: John Crispin <blogic@openwrt.org>
---
 drivers/pinctrl/pinctrl-falcon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-falcon.c b/drivers/pinctrl/pinctrl-falcon.c
index 6331c5c..249a405 100644
--- a/drivers/pinctrl/pinctrl-falcon.c
+++ b/drivers/pinctrl/pinctrl-falcon.c
@@ -170,7 +170,7 @@ static const unsigned pins_ntr[] = {GPIO4};
 static const unsigned pins_ntr8k[] = {GPIO5};
 static const unsigned pins_hrst[] = {GPIO6};
 static const unsigned pins_mdio[] = {GPIO7, GPIO8};
-static const unsigned pins_bled[] = {GPIO7, GPIO10, GPIO11,
+static const unsigned pins_bled[] = {GPIO9, GPIO10, GPIO11,
 					GPIO12, GPIO13, GPIO14};
 static const unsigned pins_asc0[] = {GPIO32, GPIO33};
 static const unsigned pins_spi[] = {GPIO34, GPIO35, GPIO36};
-- 
1.7.10.4


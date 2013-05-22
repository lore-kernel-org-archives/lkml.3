Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab3EVOcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:32:45 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59572 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192Ab3EVObn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:31:43 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5/7] pinctrl/nomadik: Standardise Pinctrl compat string for Nomadik based platforms
Date: Wed, 22 May 2013 15:22:59 +0100
Message-Id: <1369232581-18923-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369232581-18923-1-git-send-email-lee.jones@linaro.org>
References: <1369232581-18923-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 3428175..7712d93 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -2104,7 +2104,7 @@ static struct pinctrl_desc nmk_pinctrl_desc = {
 
 static const struct of_device_id nmk_pinctrl_match[] = {
 	{
-		.compatible = "stericsson,nmk-pinctrl-stn8815",
+		.compatible = "stericsson,stn8815-pinctrl",
 		.data = (void *)PINCTRL_NMK_STN8815,
 	},
 	{
-- 
1.7.10.4


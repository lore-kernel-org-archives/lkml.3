Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab3EVObr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:31:47 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:47919 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab3EVObp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:31:45 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 6/7] pinctrl/nomadik: Standardise Pinctrl compat string for DBx5x based platforms
Date: Wed, 22 May 2013 15:23:00 +0100
Message-Id: <1369232581-18923-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369232581-18923-1-git-send-email-lee.jones@linaro.org>
References: <1369232581-18923-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 7712d93..8a4f9c5 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -2108,11 +2108,11 @@ static const struct of_device_id nmk_pinctrl_match[] = {
 		.data = (void *)PINCTRL_NMK_STN8815,
 	},
 	{
-		.compatible = "stericsson,nmk-pinctrl",
+		.compatible = "stericsson,db8500-pinctrl",
 		.data = (void *)PINCTRL_NMK_DB8500,
 	},
 	{
-		.compatible = "stericsson,nmk-pinctrl-db8540",
+		.compatible = "stericsson,db8540-pinctrl",
 		.data = (void *)PINCTRL_NMK_DB8540,
 	},
 	{},
-- 
1.7.10.4


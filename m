Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab3FRJT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:19:27 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:45043 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab3FRJTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:19:22 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/4] pinctrl: spear/plgpio: Staticize spear310_o2p
Date: Tue, 18 Jun 2013 14:34:26 +0530
Message-Id: <1371546267-22093-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371546267-22093-1-git-send-email-sachin.kamat@linaro.org>
References: <1371546267-22093-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'spear310_o2p' is referenced only in this file.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/pinctrl/spear/pinctrl-plgpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/spear/pinctrl-plgpio.c b/drivers/pinctrl/spear/pinctrl-plgpio.c
index 6b090be..0a7f0bdb 100644
--- a/drivers/pinctrl/spear/pinctrl-plgpio.c
+++ b/drivers/pinctrl/spear/pinctrl-plgpio.c
@@ -441,7 +441,7 @@ static int spear310_p2o(int pin)
 	return offset;
 }
 
-int spear310_o2p(int offset)
+static int spear310_o2p(int offset)
 {
 	if (offset <= 3)
 		return 101 - offset;
-- 
1.7.9.5


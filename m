Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaJBIkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:40:49 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:61074 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaJBIkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:40:46 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 7/7] pinctrl: abx500: mark pin config as generic
Date: Thu,  2 Oct 2014 10:40:20 +0200
Message-Id: <1412239220-22495-8-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412239220-22495-1-git-send-email-linus.walleij@linaro.org>
References: <1412239220-22495-1-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is generic pin configuration, so add .is_generic.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/nomadik/pinctrl-abx500.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/nomadik/pinctrl-abx500.c b/drivers/pinctrl/nomadik/pinctrl-abx500.c
index 3b3fbb4c21c9..5b300d2d6bf8 100644
--- a/drivers/pinctrl/nomadik/pinctrl-abx500.c
+++ b/drivers/pinctrl/nomadik/pinctrl-abx500.c
@@ -1105,6 +1105,7 @@ out:
 static const struct pinconf_ops abx500_pinconf_ops = {
 	.pin_config_get = abx500_pin_config_get,
 	.pin_config_set = abx500_pin_config_set,
+	.is_generic = true,
 };
 
 static struct pinctrl_desc abx500_pinctrl_desc = {
-- 
1.9.3


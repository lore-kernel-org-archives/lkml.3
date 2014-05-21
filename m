Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaEUPPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 11:15:45 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:54608 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbaEUPPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 11:15:44 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: Enable "power-source" to be extracted from DT files
Date: Wed, 21 May 2014 18:14:57 +0300
Message-Id: <1400685297-30754-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Add "power-source" property to generic options used for DT parsing files.
This  enables drivers, which use generic pin configurations, to get the
value passed to this property.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/pinctrl/pinconf-generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 3d9a999..c7ead91 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -166,6 +166,7 @@ static struct pinconf_generic_dt_params dt_params[] = {
 	{ "input-schmitt-enable", PIN_CONFIG_INPUT_SCHMITT_ENABLE, 1 },
 	{ "input-schmitt-disable", PIN_CONFIG_INPUT_SCHMITT_ENABLE, 0 },
 	{ "input-debounce", PIN_CONFIG_INPUT_DEBOUNCE, 0 },
+	{ "power-source", PIN_CONFIG_POWER_SOURCE, 0 },
 	{ "low-power-enable", PIN_CONFIG_LOW_POWER_MODE, 1 },
 	{ "low-power-disable", PIN_CONFIG_LOW_POWER_MODE, 0 },
 	{ "output-low", PIN_CONFIG_OUTPUT, 0, },
-- 
1.8.3.2


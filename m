Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaLUVUl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 16:20:41 -0500
Received: from sauhun.de ([89.238.76.85]:52919 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbaLUVPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 16:15:39 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org
Subject: [PATCH 15/28] pinctrl: intel: drop owner assignment from platform_drivers
Date: Sun, 21 Dec 2014 22:14:36 +0100
Message-Id: <1419196495-9626-16-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This platform_driver does not need to set an owner, it will be populated by the
driver core.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Generated with coccinelle. SmPL file is in the introductory msg. The big
cleanup was pulled in this merge window. This series catches the bits fallen
through. The patches shall go in via the subsystem trees.

 drivers/pinctrl/intel/pinctrl-cherryview.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/intel/pinctrl-cherryview.c b/drivers/pinctrl/intel/pinctrl-cherryview.c
index e9f8b39d1a9f..007d25fd5fb7 100644
--- a/drivers/pinctrl/intel/pinctrl-cherryview.c
+++ b/drivers/pinctrl/intel/pinctrl-cherryview.c
@@ -1497,7 +1497,6 @@ static struct platform_driver chv_pinctrl_driver = {
 	.remove = chv_pinctrl_remove,
 	.driver = {
 		.name = "cherryview-pinctrl",
-		.owner = THIS_MODULE,
 		.acpi_match_table = chv_pinctrl_acpi_match,
 	},
 };
-- 
2.1.3


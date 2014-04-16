Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbaDPM6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 08:58:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48018 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754753AbaDPM56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 08:57:58 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: linus.walleij@linaro.org, maxime.ripard@free-electrons.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: sunxi: fix typo in module author address
Date: Wed, 16 Apr 2014 14:57:48 +0200
Message-Id: <1397653068-21788-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the MODULE_AUTHOR() comments, the author name should be
"Name <email>" or just "Name". Add the missing '>'.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 drivers/pinctrl/pinctrl-sunxi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index f9fabe9bf47d..1b0539f40e3b 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -933,6 +933,6 @@ static struct platform_driver sunxi_pinctrl_driver = {
 };
 module_platform_driver(sunxi_pinctrl_driver);
 
-MODULE_AUTHOR("Maxime Ripard <maxime.ripard@free-electrons.com");
+MODULE_AUTHOR("Maxime Ripard <maxime.ripard@free-electrons.com>");
 MODULE_DESCRIPTION("Allwinner A1X pinctrl driver");
 MODULE_LICENSE("GPL");
-- 
1.8.3.2


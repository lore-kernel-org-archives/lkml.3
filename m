Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaGBOcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:32:42 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:48850 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaGBOck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:32:40 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] MAINTAINERS: Add entry for the Renesas pin controller driver
Date: Wed,  2 Jul 2014 16:33:31 +0200
Message-Id: <1404311611-10902-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm actively maintaining the driver, let's document that.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 702ca10..158dc48 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6925,6 +6925,12 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/pinctrl/pinctrl-at91.c
 
+PIN CONTROLLER - RENESAS
+M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+L:	linux-sh@vger.kernel.org
+S:	Maintained
+F:	drivers/pinctrl/sh-pfc/
+
 PIN CONTROLLER - SAMSUNG
 M:	Tomasz Figa <t.figa@samsung.com>
 M:	Thomas Abraham <thomas.abraham@linaro.org>
-- 
1.8.5.5


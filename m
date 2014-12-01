Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaLAIV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:21:28 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49332 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752779AbaLAIVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:21:11 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 3/3] drm: panel: simple-panel: add bus format information for foxlink panel
Date: Mon,  1 Dec 2014 09:21:01 +0100
Message-Id: <1417422061-10384-8-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417422061-10384-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417422061-10384-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Foxlink's fl500wvr00-a0t supports RGB888 format.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/gpu/drm/panel/panel-simple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 66838a5..695f406 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -545,6 +545,7 @@ static const struct panel_desc foxlink_fl500wvr00_a0t = {
 		.width = 108,
 		.height = 65,
 	},
+	.bus_format = MEDIA_BUS_FMT_RGB888_1X24,
 };
 
 static const struct drm_display_mode innolux_n116bge_mode = {
-- 
1.9.1


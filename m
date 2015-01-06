Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbbAFLJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:09:39 -0500
Received: from down.free-electrons.com ([37.187.137.238]:42716 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755200AbbAFLI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:08:59 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [RESEND PATCH v5 3/3] drm: panel: simple-panel: add bus format information for foxlink panel
Date: Tue,  6 Jan 2015 12:08:45 +0100
Message-Id: <1420542525-13507-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420542525-13507-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1420542525-13507-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Foxlink's fl500wvr00-a0t supports RGB888 format.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/gpu/drm/panel/panel-simple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 4504018..6049d24 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -563,6 +563,7 @@ static const struct panel_desc foxlink_fl500wvr00_a0t = {
 		.width = 108,
 		.height = 65,
 	},
+	.bus_format = MEDIA_BUS_FMT_RGB888_1X24,
 };
 
 static const struct drm_display_mode hannstar_hsd070pww1_mode = {
-- 
1.9.1


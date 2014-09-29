Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbaI2OEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:04:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47361 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754480AbaI2OEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:04:01 -0400
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 5/5] drm: panel: simple-panel: add bus format information for foxlink panel
Date: Mon, 29 Sep 2014 16:02:43 +0200
Message-Id: <1411999363-28770-6-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411999363-28770-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1411999363-28770-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

Foxlink's fl500wvr00-a0t supports RGB888 format.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/gpu/drm/panel/panel-simple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index eb3a17e..11bff3f 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -521,6 +521,7 @@ static const struct panel_desc foxlink_fl500wvr00_a0t = {
 		.width = 108,
 		.height = 65,
 	},
+	.bus_format = VIDEO_BUS_FMT_RGB888_1X24,
 };
 
 static const struct drm_display_mode innolux_n116bge_mode = {
-- 
1.9.1


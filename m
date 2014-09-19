Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaISILv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 04:11:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbaISILq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 04:11:46 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: airlied@redhat.com
Cc: Gerd Hoffmann <kraxel@redhat.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] cirrus: add missing drm_connector_register call
Date: Fri, 19 Sep 2014 10:11:36 +0200
Message-Id: <1411114297-13910-2-git-send-email-kraxel@redhat.com>
In-Reply-To: <1411114297-13910-1-git-send-email-kraxel@redhat.com>
References: <1411114297-13910-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/gpu/drm/cirrus/cirrus_mode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/cirrus/cirrus_mode.c b/drivers/gpu/drm/cirrus/cirrus_mode.c
index e1c5c32..c7c5a9d 100644
--- a/drivers/gpu/drm/cirrus/cirrus_mode.c
+++ b/drivers/gpu/drm/cirrus/cirrus_mode.c
@@ -555,6 +555,7 @@ static struct drm_connector *cirrus_vga_init(struct drm_device *dev)
 
 	drm_connector_helper_add(connector, &cirrus_vga_connector_helper_funcs);
 
+	drm_connector_register(connector);
 	return connector;
 }
 
-- 
1.8.3.1


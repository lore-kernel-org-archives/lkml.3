Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaISILt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 04:11:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbaISILq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 04:11:46 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: airlied@redhat.com
Cc: Gerd Hoffmann <kraxel@redhat.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] bochs: add missing drm_connector_register call
Date: Fri, 19 Sep 2014 10:11:37 +0200
Message-Id: <1411114297-13910-3-git-send-email-kraxel@redhat.com>
In-Reply-To: <1411114297-13910-1-git-send-email-kraxel@redhat.com>
References: <1411114297-13910-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/gpu/drm/bochs/bochs_kms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bochs/bochs_kms.c b/drivers/gpu/drm/bochs/bochs_kms.c
index 9d7346b..6b7efcf3 100644
--- a/drivers/gpu/drm/bochs/bochs_kms.c
+++ b/drivers/gpu/drm/bochs/bochs_kms.c
@@ -250,6 +250,7 @@ static void bochs_connector_init(struct drm_device *dev)
 			   DRM_MODE_CONNECTOR_VIRTUAL);
 	drm_connector_helper_add(connector,
 				 &bochs_connector_connector_helper_funcs);
+	drm_connector_register(connector);
 }
 
 
-- 
1.8.3.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab3DZRud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 13:50:33 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:64108 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab3DZRub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 13:50:31 -0400
From: Emil Goode <emilgoode@gmail.com>
To: airlied@linux.ie, swarren@wwwdotorg.org
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] drm/tegra: Include header drm/drm.h
Date: Fri, 26 Apr 2013 19:49:51 +0200
Message-Id: <1366998591-8508-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include definitions of used types by including drm/drm.h

Sparse output:
/usr/include/drm/tegra_drm.h:21:
	found __[us]{8,16,32,64} type without
	#include <linux/types.h>

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 include/uapi/drm/tegra_drm.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/drm/tegra_drm.h b/include/uapi/drm/tegra_drm.h
index 6e132a2..73bde4e 100644
--- a/include/uapi/drm/tegra_drm.h
+++ b/include/uapi/drm/tegra_drm.h
@@ -17,6 +17,8 @@
 #ifndef _UAPI_TEGRA_DRM_H_
 #define _UAPI_TEGRA_DRM_H_
 
+#include <drm/drm.h>
+
 struct drm_tegra_gem_create {
 	__u64 size;
 	__u32 flags;
-- 
1.7.10.4


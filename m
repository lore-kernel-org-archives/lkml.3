Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaIAG0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:26:53 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:52260 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbaIAG0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:26:51 -0400
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, mikko.rapeli@iki.fi
Subject: [RFC PATCH v2 10/27] vmwgfx_drm.h: include drm/drm.h instead of drm.h in userspace
Date: Mon,  1 Sep 2014 09:26:01 +0300
Message-Id: <1409552778-2537-11-git-send-email-mikko.rapeli@iki.fi>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409552778-2537-1-git-send-email-mikko.rapeli@iki.fi>
References: <1408660449-4011-1-git-send-email-mikko.rapeli@iki.fi>
 <1409552778-2537-1-git-send-email-mikko.rapeli@iki.fi>
X-SA-Exim-Connect-IP: 217.30.184.161
X-SA-Exim-Mail-From: mcfrisk@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes compilation error:

drm/vmwgfx_drm.h:31:17: fatal error: drm.h: No such file or directory

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/vmwgfx_drm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/drm/vmwgfx_drm.h b/include/uapi/drm/vmwgfx_drm.h
index 4fc66f6..c472bedb 100644
--- a/include/uapi/drm/vmwgfx_drm.h
+++ b/include/uapi/drm/vmwgfx_drm.h
@@ -29,7 +29,7 @@
 #define __VMWGFX_DRM_H__
 
 #ifndef __KERNEL__
-#include <drm.h>
+#include <drm/drm.h>
 #endif
 
 #define DRM_VMW_MAX_SURFACE_FACES 6
-- 
2.1.0


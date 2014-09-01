Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaIAGaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:30:35 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:54961 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbaIAG0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:26:40 -0400
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, mikko.rapeli@iki.fi
Subject: [RFC PATCH v2 24/27] via_drm.h: include linux/types.h instead of non-existing via_drmclient.h
Date: Mon,  1 Sep 2014 09:26:15 +0300
Message-Id: <1409552778-2537-25-git-send-email-mikko.rapeli@iki.fi>
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

Fixes compiler error:

drm/via_drm.h:36:27: fatal error: via_drmclient.h: No such file or directory

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/via_drm.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/uapi/drm/via_drm.h b/include/uapi/drm/via_drm.h
index 8b0533c..791531e 100644
--- a/include/uapi/drm/via_drm.h
+++ b/include/uapi/drm/via_drm.h
@@ -24,6 +24,7 @@
 #ifndef _VIA_DRM_H_
 #define _VIA_DRM_H_
 
+#include <linux/types.h>
 #include <drm/drm.h>
 
 /* WARNING: These defines must be the same as what the Xserver uses.
@@ -33,9 +34,6 @@
 #ifndef _VIA_DEFINES_
 #define _VIA_DEFINES_
 
-#ifndef __KERNEL__
-#include "via_drmclient.h"
-#endif
 
 #define VIA_NR_SAREA_CLIPRECTS		8
 #define VIA_NR_XVMC_PORTS               10
-- 
2.1.0


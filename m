Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaIAG0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:26:44 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:49145 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbaIAG0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:26:40 -0400
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, mikko.rapeli@iki.fi
Subject: [RFC PATCH v2 23/27] r128_drm.h: include drm/drm.h
Date: Mon,  1 Sep 2014 09:26:14 +0300
Message-Id: <1409552778-2537-24-git-send-email-mikko.rapeli@iki.fi>
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

Fixes compile error:

drm/r128_drm.h:156:23: error: array type has incomplete element type
  struct drm_clip_rect boxes[R128_NR_SAREA_CLIPRECTS];

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/r128_drm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/drm/r128_drm.h b/include/uapi/drm/r128_drm.h
index 8d8878b..76b0aa3 100644
--- a/include/uapi/drm/r128_drm.h
+++ b/include/uapi/drm/r128_drm.h
@@ -33,6 +33,8 @@
 #ifndef __R128_DRM_H__
 #define __R128_DRM_H__
 
+#include <drm/drm.h>
+
 /* WARNING: If you change any of these defines, make sure to change the
  * defines in the X server file (r128_sarea.h)
  */
-- 
2.1.0


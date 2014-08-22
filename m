Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbaHVME4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:04:56 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:55389 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026AbaHVMEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:04:53 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: David Airlie <airlied@linux.ie>, Inki Dae <inki.dae@samsung.com>
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 2/2] drivers/gpu/drm/vmwgfx/vmwgfx_fence.h: Add missing #define
Date: Fri, 22 Aug 2014 14:04:36 +0200
Message-Id: <1408709076-13260-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408709076-13260-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1408709076-13260-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name of the macro suggests that the include guard idiom was meant,
but the #define was missing.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.h b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.h
index faf2e78..1b48a22 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.h
@@ -26,6 +26,7 @@
  **************************************************************************/
 
 #ifndef _VMWGFX_FENCE_H_
+#define _VMWGFX_FENCE_H_
 
 #define VMW_FENCE_WAIT_TIMEOUT (5*HZ)
 
-- 
1.9.2


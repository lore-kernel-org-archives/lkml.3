Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab3HTQRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:17:19 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:37071 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab3HTQRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:17:17 -0400
Subject: [PATCH v3 trivial 5/7] DRM: comment: `halve' -> `half'
Date: Tue, 20 Aug 2013 16:05:22 -0000
From: Michael Witten <mfwitten@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@infradead.org>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Message-ID: <ccc8dbd1e55946f5ad1ddaa36256f58b-mfwitten@gmail.com>
In-Reply-To: <4cd8ab80726c43cf90243970c20f50ef-mfwitten@gmail.com>
References: <4cd8ab80726c43cf90243970c20f50ef-mfwitten@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Thu, 15 Sep 2011 21:07:26 +0000

Signed-off-by: Michael Witten <mfwitten@gmail.com>
---
 drivers/gpu/drm/drm_irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index f92da0a..062dc22 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -497,8 +497,8 @@ void drm_calc_timestamping_constants(struct drm_crtc *crtc)
 	/* Dot clock in Hz: */
 	dotclock = (u64) crtc->hwmode.clock * 1000;
 
-	/* Fields of interlaced scanout modes are only halve a frame duration.
+	/* Fields of interlaced scanout modes are only half a frame duration.
-	 * Double the dotclock to get halve the frame-/line-/pixelduration.
+	 * Double the dotclock to get half the frame-/line-/pixelduration.
 	 */
 	if (crtc->hwmode.flags & DRM_MODE_FLAG_INTERLACE)
 		dotclock *= 2;
-- 
1.7.11.2.252.gc4a64c8


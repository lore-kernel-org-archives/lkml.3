Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3CMITI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 04:19:08 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:61258 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab3CMITG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 04:19:06 -0400
Date: Wed, 13 Mar 2013 16:19:55 +0800
From: Wang YanQing <udknight@gmail.com>
To: airlied@linux.ie
Cc: airlied@redhat.com, alan@linux.intel.com, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH]gma500: remove unused drm_psb_no_fb
Message-ID: <20130313081955.GA19276@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, airlied@linux.ie,
	airlied@redhat.com, alan@linux.intel.com,
	kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit f9f23a77f07506a32d9dc1d925bf85c0e7507b66(gma500: remove no_fb bits)
remove all the drm_psb_no_fb relations code in gma500 except this line code,
so remove it also.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/gpu/drm/gma500/psb_drv.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/gma500/psb_drv.h b/drivers/gpu/drm/gma500/psb_drv.h
index a7fd6c4..6053b8a 100644
--- a/drivers/gpu/drm/gma500/psb_drv.h
+++ b/drivers/gpu/drm/gma500/psb_drv.h
@@ -876,7 +876,6 @@ extern const struct psb_ops cdv_chip_ops;
 #define PSB_D_MSVDX   (1 << 9)
 #define PSB_D_TOPAZ   (1 << 10)
 
-extern int drm_psb_no_fb;
 extern int drm_idle_check_interval;
 
 /*
-- 
1.7.12.4.dirty

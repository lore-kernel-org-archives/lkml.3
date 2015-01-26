Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbbAZQrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:47:51 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:47089 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbbAZQrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:47:48 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: daniel.vetter@intel.com
Cc: jani.nikula@linux.intel.com, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: gpu: drm: i915: intel_fifo_underrun.c: Fix a typo in comment
Date: Mon, 26 Jan 2015 17:47:32 +0100
Message-Id: <1422290852-4060-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment for intel_cpu_fifo_underrun_irq_handler() is not consistent
with the code and the rest of the comment for this routine. This patch
fixes this typo in comment.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/gpu/drm/i915/intel_fifo_underrun.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_fifo_underrun.c b/drivers/gpu/drm/i915/intel_fifo_underrun.c
index 77af512..04e248d 100644
--- a/drivers/gpu/drm/i915/intel_fifo_underrun.c
+++ b/drivers/gpu/drm/i915/intel_fifo_underrun.c
@@ -341,7 +341,7 @@ bool intel_set_pch_fifo_underrun_reporting(struct drm_i915_private *dev_priv,
 }
 
 /**
- * intel_pch_fifo_underrun_irq_handler - handle PCH fifo underrun interrupt
+ * intel_cpu_fifo_underrun_irq_handler - handle CPU fifo underrun interrupt
  * @dev_priv: i915 device instance
  * @pipe: (CPU) pipe to set state for
  *
-- 
2.1.0


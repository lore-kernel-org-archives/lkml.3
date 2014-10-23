Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbaJWJxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 05:53:17 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:60930 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbaJWJw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 05:52:56 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        David Airlie <airlied@linux.ie>
Subject: [PATCH/TRIVIAL 2/4] drm/i915: Move newline to end of error message
Date: Thu, 23 Oct 2014 11:52:55 +0200
Message-Id: <1414057977-4191-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414057977-4191-1-git-send-email-geert+renesas@glider.be>
References: <1414057977-4191-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the error message is needlessly splitted across two lines.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: David Airlie <airlied@linux.ie>
---
 drivers/gpu/drm/i915/i915_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 3201986bf25ebaf6..359957656b5a38d0 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -2595,7 +2595,7 @@ static irqreturn_t gen8_irq_handler(int irq, void *arg)
 			}
 
 			if (pipe_iir & GEN8_DE_PIPE_IRQ_FAULT_ERRORS) {
-				DRM_ERROR("Fault errors on pipe %c\n: 0x%08x",
+				DRM_ERROR("Fault errors on pipe %c: 0x%08x\n",
 					  pipe_name(pipe),
 					  pipe_iir & GEN8_DE_PIPE_IRQ_FAULT_ERRORS);
 			}
-- 
1.9.1


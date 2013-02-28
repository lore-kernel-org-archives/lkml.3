Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932Ab3B1PAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:00:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42433 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729Ab3B1OuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:50:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 107/139] drm/i915: add missing \n to UTS_RELEASE in the error_state
Date: Thu, 28 Feb 2013 14:44:17 +0000
Message-Id: <1362062689-2567-108-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit fdfa175d0a9cfa2082ce24e67e284e5acbba452a upstream.

Amending
commit 4518f611ba21ba165ea3714055938a8984a44ff9
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed Jan 23 16:16:35 2013 +0100

    drm/i915: dump UTS_RELEASE into the error_state

Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 3459e27..5ec5222 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -710,7 +710,7 @@ static int i915_error_state(struct seq_file *m, void *unused)
 
 	seq_printf(m, "Time: %ld s %ld us\n", error->time.tv_sec,
 		   error->time.tv_usec);
-	seq_printf(m, "Kernel: " UTS_RELEASE);
+	seq_printf(m, "Kernel: " UTS_RELEASE "\n");
 	seq_printf(m, "PCI ID: 0x%04x\n", dev->pci_device);
 	seq_printf(m, "EIR: 0x%08x\n", error->eir);
 	seq_printf(m, "IER: 0x%08x\n", error->ier);
-- 
1.8.1.2


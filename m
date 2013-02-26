Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab3BZX6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:58:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760284Ab3BZX57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 088/150] drm/i915: add missing \n to UTS_RELEASE in the error_state
Date: Tue, 26 Feb 2013 15:55:45 -0800
Message-Id: <20130226235533.233374763@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -691,7 +691,7 @@ static int i915_error_state(struct seq_f
 
 	seq_printf(m, "Time: %ld s %ld us\n", error->time.tv_sec,
 		   error->time.tv_usec);
-	seq_printf(m, "Kernel: " UTS_RELEASE);
+	seq_printf(m, "Kernel: " UTS_RELEASE "\n");
 	seq_printf(m, "PCI ID: 0x%04x\n", dev->pci_device);
 	seq_printf(m, "EIR: 0x%08x\n", error->eir);
 	seq_printf(m, "IER: 0x%08x\n", error->ier);



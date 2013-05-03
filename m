Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763557Ab3ECUk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:40:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763233Ab3ECUkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:40:25 -0400
Date: Fri, 3 May 2013 16:40:09 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: rusty@rustcorp.com.au, mst@redhat.com
Subject: Add missing module license tag to vring helpers.
Message-ID: <20130503204009.GA29376@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, rusty@rustcorp.com.au,
	mst@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[  624.286653] vringh: module license 'unspecified' taints kernel.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index bff0775..5174eba 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -3,6 +3,7 @@
  *
  * Since these may be in userspace, we use (inline) accessors.
  */
+#include <linux/module.h>
 #include <linux/vringh.h>
 #include <linux/virtio_ring.h>
 #include <linux/kernel.h>
@@ -1005,3 +1006,5 @@ int vringh_need_notify_kern(struct vringh *vrh)
 	return __vringh_need_notify(vrh, getu16_kern);
 }
 EXPORT_SYMBOL(vringh_need_notify_kern);
+
+MODULE_LICENSE("GPL");

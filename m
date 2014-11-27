Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaK0Gla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:41:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaK0Gl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:41:28 -0500
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: [PATCH net-next] vhost: remove unnecessary forward declarations in vhost.h
Date: Thu, 27 Nov 2014 14:41:21 +0800
Message-Id: <1417070481-10331-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vhost.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 3eda654..7d039ef 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -12,8 +12,6 @@
 #include <linux/virtio_ring.h>
 #include <linux/atomic.h>
 
-struct vhost_device;
-
 struct vhost_work;
 typedef void (*vhost_work_fn_t)(struct vhost_work *work);
 
@@ -54,8 +52,6 @@ struct vhost_log {
 	u64 len;
 };
 
-struct vhost_virtqueue;
-
 /* The virtqueue structure describes a queue attached to a device. */
 struct vhost_virtqueue {
 	struct vhost_dev *dev;
-- 
1.9.1


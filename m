Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbbAOMwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:52:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868AbbAOMwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:52:33 -0500
Date: Thu, 15 Jan 2015 14:52:19 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] virtio_pci_modern: comment tweak
Message-ID: <1421326335-22796-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment was incorrectly copied over
from legacy driver. Fix it up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci_modern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index b877705..17f0228 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -1,5 +1,5 @@
 /*
- * Virtio PCI driver - legacy device support
+ * Virtio PCI driver - modern (virtio 1.0) device support
  *
  * This module allows virtio devices to be used over a virtual PCI device.
  * This can be used with QEMU based VMMs like KVM or Xen.
-- 
MST

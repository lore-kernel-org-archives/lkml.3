Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbbAOMSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:18:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbbAOMSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:18:37 -0500
Date: Thu, 15 Jan 2015 14:18:30 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 1/2] virtio_pci: Kconfig grammar fix
Message-ID: <1421324298-21749-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This drivers -> this driver.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 00b2286..8286b63 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -12,7 +12,7 @@ config VIRTIO_PCI
 	depends on PCI
 	select VIRTIO
 	---help---
-	  This drivers provides support for virtio based paravirtual device
+	  This driver provides support for virtio based paravirtual device
 	  drivers over PCI.  This requires that your VMM has appropriate PCI
 	  virtio backends.  Most QEMU based VMMs should support these devices
 	  (like KVM or Xen).
-- 
MST


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbbAOMSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:18:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbbAOMSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:18:39 -0500
Date: Thu, 15 Jan 2015 14:18:33 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 2/2] virtio_pci: drop Kconfig warnings
Message-ID: <1421324298-21749-2-git-send-email-mst@redhat.com>
References: <1421324298-21749-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421324298-21749-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ABI *is* stable, and has been for a while now.
Drop Kconfig warning saying that it's not guaranteed
to work.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 8286b63..083fb45 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -17,9 +17,6 @@ config VIRTIO_PCI
 	  virtio backends.  Most QEMU based VMMs should support these devices
 	  (like KVM or Xen).
 
-	  Currently, the ABI is not considered stable so there is no guarantee
-	  that this version of the driver will work with your VMM.
-
 	  If unsure, say M.
 
 config VIRTIO_BALLOON
-- 
MST


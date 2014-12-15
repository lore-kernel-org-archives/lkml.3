Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbaLOVYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:24:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbaLOVXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:23:20 -0500
Date: Mon, 15 Dec 2014 23:23:15 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 3/6] virtio_pci_common.h: drop VIRTIO_PCI_NO_LEGACY
Message-ID: <1418678575-31755-4-git-send-email-mst@redhat.com>
References: <1418678575-31755-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418678575-31755-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Legacy drivers use virtio_pci_common.h too, we should not
define VIRTIO_PCI_NO_LEGACY there.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci_common.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index d840dad..38d99ad 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -27,7 +27,6 @@
 #include <linux/virtio.h>
 #include <linux/virtio_config.h>
 #include <linux/virtio_ring.h>
-#define VIRTIO_PCI_NO_LEGACY
 #include <linux/virtio_pci.h>
 #include <linux/highmem.h>
 #include <linux/spinlock.h>
-- 
MST


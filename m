Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbaLHNG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:06:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568AbaLHNGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:06:42 -0500
Date: Mon, 8 Dec 2014 15:06:36 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 9/9] virtio_pci: update file descriptions and copyright
Message-ID: <1418043812-25753-10-git-send-email-mst@redhat.com>
References: <1418043812-25753-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418043812-25753-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's been a lot of changes since 2007.
List main authors, add Red Hat copyright.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci.h        | 5 ++++-
 drivers/virtio/virtio_pci.c        | 5 ++++-
 drivers/virtio/virtio_pci_legacy.c | 5 ++++-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_pci.h b/drivers/virtio/virtio_pci.h
index a3b1259..fba383c 100644
--- a/drivers/virtio/virtio_pci.h
+++ b/drivers/virtio/virtio_pci.h
@@ -1,15 +1,18 @@
 #ifndef _DRIVERS_VIRTIO_VIRTIO_PCI_H
 #define _DRIVERS_VIRTIO_VIRTIO_PCI_H
 /*
- * Virtio PCI driver
+ * Virtio PCI driver - APIs for common functionality for all device versions
  *
  * This module allows virtio devices to be used over a virtual PCI device.
  * This can be used with QEMU based VMMs like KVM or Xen.
  *
  * Copyright IBM Corp. 2007
+ * Copyright Red Hat, Inc. 2014
  *
  * Authors:
  *  Anthony Liguori  <aliguori@us.ibm.com>
+ *  Rusty Russell <rusty@rustcorp.com.au>
+ *  Michael S. Tsirkin <mst@redhat.com>
  *
  * This work is licensed under the terms of the GNU GPL, version 2 or later.
  * See the COPYING file in the top-level directory.
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 6c7e186..c263f67 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -1,13 +1,16 @@
 /*
- * Virtio PCI driver
+ * Virtio PCI driver - common functionality for all device versions
  *
  * This module allows virtio devices to be used over a virtual PCI device.
  * This can be used with QEMU based VMMs like KVM or Xen.
  *
  * Copyright IBM Corp. 2007
+ * Copyright Red Hat, Inc. 2014
  *
  * Authors:
  *  Anthony Liguori  <aliguori@us.ibm.com>
+ *  Rusty Russell <rusty@rustcorp.com.au>
+ *  Michael S. Tsirkin <mst@redhat.com>
  *
  * This work is licensed under the terms of the GNU GPL, version 2 or later.
  * See the COPYING file in the top-level directory.
diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index 9fdec9a..1ca4422 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -1,13 +1,16 @@
 /*
- * Virtio PCI driver
+ * Virtio PCI driver - legacy device support
  *
  * This module allows virtio devices to be used over a virtual PCI device.
  * This can be used with QEMU based VMMs like KVM or Xen.
  *
  * Copyright IBM Corp. 2007
+ * Copyright Red Hat, Inc. 2014
  *
  * Authors:
  *  Anthony Liguori  <aliguori@us.ibm.com>
+ *  Rusty Russell <rusty@rustcorp.com.au>
+ *  Michael S. Tsirkin <mst@redhat.com>
  *
  * This work is licensed under the terms of the GNU GPL, version 2 or later.
  * See the COPYING file in the top-level directory.
-- 
MST


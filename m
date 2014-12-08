Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbaLHNJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:09:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490AbaLHNGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:06:24 -0500
Date: Mon, 8 Dec 2014 15:06:18 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 2/9] virtio_pci: fix coding style for structs
Message-ID: <1418043812-25753-3-git-send-email-mst@redhat.com>
References: <1418043812-25753-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418043812-25753-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

should be

struct foo {
}

not

struct foo
{
}

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index ee1b54c..6f3db1f 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -32,8 +32,7 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION("1");
 
 /* Our device structure */
-struct virtio_pci_device
-{
+struct virtio_pci_device {
 	struct virtio_device vdev;
 	struct pci_dev *pci_dev;
 
@@ -72,8 +71,7 @@ enum {
 	VP_MSIX_VQ_VECTOR = 1,
 };
 
-struct virtio_pci_vq_info
-{
+struct virtio_pci_vq_info {
 	/* the actual virtqueue */
 	struct virtqueue *vq;
 
-- 
MST


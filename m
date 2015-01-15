Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbbAOLnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:43:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbbAOLnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:43:32 -0500
Date: Thu, 15 Jan 2015 13:43:26 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] virtio_blk: coding style fixes
Message-ID: <1421322201-21203-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of our code has
struct foo {
}

Fix two instances where blk is inconsistent.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/block/virtio_blk.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 7164da8..c5730d3 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -28,8 +28,7 @@ struct virtio_blk_vq {
 	char name[VQ_NAME_LEN];
 } ____cacheline_aligned_in_smp;
 
-struct virtio_blk
-{
+struct virtio_blk {
 	struct virtio_device *vdev;
 
 	/* The disk structure for the kernel. */
@@ -52,8 +51,7 @@ struct virtio_blk
 	struct virtio_blk_vq *vqs;
 };
 
-struct virtblk_req
-{
+struct virtblk_req {
 	struct request *req;
 	struct virtio_blk_outhdr out_hdr;
 	struct virtio_scsi_inhdr in_hdr;
-- 
MST

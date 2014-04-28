Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaD1GbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 02:31:24 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:52510 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaD1GbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 02:31:20 -0400
From: Jerry Snitselaar <dev@snitselaar.org>
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] virtio_scsi: space required before open parenthesis
Date: Sun, 27 Apr 2014 23:31:07 -0700
Message-Id: <1398666667-24721-2-git-send-email-dev@snitselaar.org>
X-Mailer: git-send-email 2.0.0.rc0
In-Reply-To: <1398666667-24721-1-git-send-email-dev@snitselaar.org>
References: <1398666667-24721-1-git-send-email-dev@snitselaar.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style warnings from checkpatch

Signed-off-by: Jerry Snitselaar <dev@snitselaar.org>
---
 drivers/scsi/virtio_scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 9f2fccc..9248a1e 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -723,7 +723,7 @@ static struct scsi_host_template virtscsi_host_template_multi = {
 	do { \
 		typeof(((struct virtio_scsi_config *)0)->fld) __val = (val); \
 		virtio_cwrite(vdev, struct virtio_scsi_config, fld, &__val); \
-	} while(0)
+	} while (0)
 
 static void __virtscsi_set_affinity(struct virtio_scsi *vscsi, bool affinity)
 {
@@ -771,7 +771,7 @@ static int virtscsi_cpu_callback(struct notifier_block *nfb,
 {
 	struct virtio_scsi *vscsi = container_of(nfb, struct virtio_scsi, nb);
 
-	switch(action) {
+	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 	case CPU_DEAD:
-- 
2.0.0.rc0


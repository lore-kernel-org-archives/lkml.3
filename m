Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaCFJju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:39:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbaCFJjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:39:47 -0500
From: Fam Zheng <famz@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com
Subject: [PATCH] virtio-scsi: Change sense buffer size to 252
Date: Thu,  6 Mar 2014 16:47:40 +0800
Message-Id: <1394095660-15075-1-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to SPC-4, section 4.5.2.1, 252 is the limit of sense data. So
increase the value.

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 include/linux/virtio_scsi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/virtio_scsi.h b/include/linux/virtio_scsi.h
index 4195b97..a437f7f 100644
--- a/include/linux/virtio_scsi.h
+++ b/include/linux/virtio_scsi.h
@@ -28,7 +28,7 @@
 #define _LINUX_VIRTIO_SCSI_H
 
 #define VIRTIO_SCSI_CDB_SIZE   32
-#define VIRTIO_SCSI_SENSE_SIZE 96
+#define VIRTIO_SCSI_SENSE_SIZE 252
 
 /* SCSI command request, followed by data-out */
 struct virtio_scsi_cmd_req {
-- 
1.9.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaCXRvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 13:51:52 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:32789 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbaCXRvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 13:51:50 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        LDOC <linux-doc@vger.kernel.org>, Rob Landley <rob@landley.net>
Subject: [PATCH] v4l2-pci-skeleton: fix typo while retrieving the skel_buffer
Date: Mon, 24 Mar 2014 23:21:29 +0530
Message-Id: <1395683489-25986-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Documentation/video4linux/v4l2-pci-skeleton.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/video4linux/v4l2-pci-skeleton.c b/Documentation/video4linux/v4l2-pci-skeleton.c
index 3a1c0d2..61a56f4 100644
--- a/Documentation/video4linux/v4l2-pci-skeleton.c
+++ b/Documentation/video4linux/v4l2-pci-skeleton.c
@@ -87,7 +87,7 @@ struct skel_buffer {
 
 static inline struct skel_buffer *to_skel_buffer(struct vb2_buffer *vb2)
 {
-	return container_of(vb2, struct skel_buffer, vb);
+	return container_of(vb2, struct skel_buffer, vb2);
 }
 
 static const struct pci_device_id skeleton_pci_tbl[] = {
-- 
1.7.9.5


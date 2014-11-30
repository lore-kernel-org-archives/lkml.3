Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaK3MWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:22:46 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14386 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaK3MWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:22:45 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/4] UBI: Fastmap: Add blank line after declarations
Date: Sun, 30 Nov 2014 13:22:34 +0100
Message-Id: <1417350157-9373-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417350157-9373-1-git-send-email-richard@nod.at>
References: <1417350157-9373-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another checkpatch complaint:
WARNING: Missing a blank line after declarations

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap-wl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/ubi/fastmap-wl.c b/drivers/mtd/ubi/fastmap-wl.c
index 7a72af2..067aa90 100644
--- a/drivers/mtd/ubi/fastmap-wl.c
+++ b/drivers/mtd/ubi/fastmap-wl.c
@@ -21,6 +21,7 @@
 static void update_fastmap_work_fn(struct work_struct *wrk)
 {
 	struct ubi_device *ubi = container_of(wrk, struct ubi_device, fm_work);
+
 	ubi_update_fastmap(ubi);
 	spin_lock(&ubi->wl_lock);
 	ubi->fm_work_scheduled = 0;
-- 
1.8.4.5


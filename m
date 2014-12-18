Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaLRLDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 06:03:04 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52275 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaLRLDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 06:03:00 -0500
From: Karthik Nayak <karthik.188@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        Karthik Nayak <karthik.188@gmail.com>
Subject: [PATCH] staging: gdm724x: remove prohibited space before the comma
Date: Thu, 18 Dec 2014 16:32:47 +0530
Message-Id: <1418900567-16056-1-git-send-email-karthik.188@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove checkpatch error of prohibited space before the comma.

Signed-off-by: Karthik Nayak <karthik.188@gmail.com>
---
 drivers/staging/gdm724x/gdm_mux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gdm724x/gdm_mux.c b/drivers/staging/gdm724x/gdm_mux.c
index b5b063a..d1ab996 100644
--- a/drivers/staging/gdm724x/gdm_mux.c
+++ b/drivers/staging/gdm724x/gdm_mux.c
@@ -220,7 +220,7 @@ static int up_to_host(struct mux_rx *r)
 static void do_rx(struct work_struct *work)
 {
 	struct mux_dev *mux_dev =
-		container_of(work, struct mux_dev , work_rx.work);
+		container_of(work, struct mux_dev, work_rx.work);
 	struct mux_rx *r;
 	struct rx_cxt *rx = (struct rx_cxt *)&mux_dev->rx;
 	unsigned long flags;
-- 
2.1.3


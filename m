Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbbADIYn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 03:24:43 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:35475 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbADIYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 03:24:41 -0500
From: Ning Zhou <zhou.ning.gd@gmail.com>
To: gregkh@linuxfoundation.org
Cc: gulsah.1004@gmail.com, daniel.dy.ngu@gmail.com, josh@joshtriplett.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ning Zhou <zhou.ning.gd@gmail.com>
Subject: [PATCH] staging: gdm724x: fix space coding style issue in gdm_mux.c
Date: Sun,  4 Jan 2015 09:23:44 +0100
Message-Id: <1420359824-7081-1-git-send-email-zhou.ning.gd@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to fix a space error found by the checkpatch.pl in
file gdm_mux.c.

Signed-off-by: Ning Zhou <zhou.ning.gd@gmail.com>
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
1.9.1


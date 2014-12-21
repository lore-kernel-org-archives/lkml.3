Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaLUCso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 21:48:44 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35159 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaLUCsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 21:48:43 -0500
From: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
To: gregkh@linuxfoundation.org
Cc: josh@joshtriplett.org, gulsah.1004@gmail.com, md.jamalmohiuddin@gmail.com,
        daniel.dy.ngu@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging : gdm724x: Remove space before , in function arguments
Date: Sun, 21 Dec 2014 08:18:19 +0530
Message-Id: <1419130099-6256-1-git-send-email-md.jamalmohiuddin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch solves space prohibited before , warning in gdm_mux.c

Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
---
 drivers/staging/gdm724x/gdm_mux.c |    2 +-
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
1.7.9.5


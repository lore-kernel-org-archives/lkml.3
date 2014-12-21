Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaLUKpA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 05:45:00 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59578 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaLUKo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 05:44:58 -0500
From: Robert Nachlinger <robert.nachlinger@googlemail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Robert Nachlinger <robert.nachlinger@googlemail.com>
Subject: [PATCH] Staging: gdm724x: fix space before comma coding style issue in gdm_mux.c
Date: Sun, 21 Dec 2014 11:44:43 +0100
Message-Id: <1419158683-6113-1-git-send-email-robert.nachlinger@googlemail.com>
X-Mailer: git-send-email 2.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the gdm_mux.c file that fixes a space before comma
coding style issue found by the checkpatch.pl tool.

Signed-off-by: Robert Nachlinger <robert.nachlinger@googlemail.com>
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
2.2.0


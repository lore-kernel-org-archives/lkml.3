Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaLROJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 09:09:46 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63449 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaLROJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 09:09:44 -0500
From: Robert Nachlinger <robert.nachlinger@googlemail.com>
To: gregkh@linuxfoundation.org
Cc: daniel.dy.ngu@gmail.com, josh@joshtriplett.org, gulsah.1004@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Robert Nachlinger <robert.nachlinger@googlemail.com>
Subject: [PATCH] Staging: gdm724x: fix space before comma coding style issue in gdm_mux.c
Date: Thu, 18 Dec 2014 15:09:09 +0100
Message-Id: <1418911749-7935-1-git-send-email-robert.nachlinger@googlemail.com>
X-Mailer: git-send-email 2.2.0
Signed-off-by: Robert Nachlinger <robert.nachlinger@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


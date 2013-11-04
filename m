Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab3KDMxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 07:53:39 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:60747 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab3KDMxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 07:53:38 -0500
From: Simon Crequer <simoncrequer@gmail.com>
To: lidza.louina@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Simon Crequer <simoncrequer@gmail.com>
Subject: [PATCH] Staging: dgnc: dgnc_cls.c: fixed a brace coding style issue
Date: Tue,  5 Nov 2013 01:53:28 +1300
Message-Id: <1383569608-8548-1-git-send-email-simoncrequer@gmail.com>
X-Mailer: git-send-email 1.8.2.1 (Apple Git-45)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Simon Crequer <simoncrequer@gmail.com>
---
 drivers/staging/dgnc/dgnc_cls.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_cls.c b/drivers/staging/dgnc/dgnc_cls.c
index 117e158..357d000 100644
--- a/drivers/staging/dgnc/dgnc_cls.c
+++ b/drivers/staging/dgnc/dgnc_cls.c
@@ -1305,9 +1305,9 @@ static uint cls_get_uart_bytes_left(struct channel_t *ch)
 
 	/* Determine whether the Transmitter is empty or not */
 	if (!(lsr & UART_LSR_TEMT)) {
-		if (ch->ch_flags & CH_TX_FIFO_EMPTY) {
+		if (ch->ch_flags & CH_TX_FIFO_EMPTY)
 			tasklet_schedule(&ch->ch_bd->helper_tasklet);
-		}
+
 		left = 1;
 	}
 	else {
-- 
1.8.2.1 (Apple Git-45)


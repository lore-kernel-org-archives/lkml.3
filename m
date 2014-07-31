Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbaGaNa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:30:58 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63501 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaGaNa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:30:57 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        tklauser@distanz.ch, Seunghun Lee <waydi1@gmail.com>,
        Lidza Louina <lidza.louina@gmail.com>,
        Mark Hounschell <markh@compro.net>
Subject: [PATCH 1/2] staging: dgnc: rephrase comment
Date: Thu, 31 Jul 2014 22:30:32 +0900
Message-Id: <1406813432-4369-1-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rephrase comment to explain original intention of function.

CC: Lidza Louina <lidza.louina@gmail.com>
CC: Mark Hounschell <markh@compro.net>
Suggested-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 drivers/staging/dgnc/dgnc_cls.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_cls.c b/drivers/staging/dgnc/dgnc_cls.c
index 4b65306..5a76a8e 100644
--- a/drivers/staging/dgnc/dgnc_cls.c
+++ b/drivers/staging/dgnc/dgnc_cls.c
@@ -1040,11 +1040,11 @@ static void cls_flush_uart_read(struct channel_t *ch)
 	 * For complete POSIX compatibility, we should be purging the
 	 * read FIFO in the UART here.
 	 *
-	 * However, doing the statement below also incorrectly flushes
-	 * write data as well as just basically trashing the FIFO.
+	 * However, clearing the read FIFO (UART_FCR_CLEAR_RCVR) also
+	 * incorrectly flushes write data as well as just basically trashing the
+	 * FIFO.
 	 *
-	 * I believe this is a BUG in this UART.
-	 * So for now, we will leave the code #ifdef'ed out...
+	 * Presumably, this is a bug in this UART.
 	 */
 
 	udelay(10);
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030230AbaEQQdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 12:33:44 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:52478 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030185AbaEQQdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 12:33:41 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Masaru Nomura <massa.nomura@gmail.com>
Subject: [PATCH 2/4] staging: dgnc: dgnc_neo: Fix indenting of if statement
Date: Sat, 17 May 2014 17:30:52 +0100
Message-Id: <1400344254-13007-3-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400344254-13007-1-git-send-email-massa.nomura@gmail.com>
References: <1400344254-13007-1-git-send-email-massa.nomura@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix indenting of if statement in dgnc_neo.c so that an open brace
follows if-condition part to meet kernel coding style.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 drivers/staging/dgnc/dgnc_neo.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_neo.c b/drivers/staging/dgnc/dgnc_neo.c
index e87cf49..8988346 100644
--- a/drivers/staging/dgnc/dgnc_neo.c
+++ b/drivers/staging/dgnc/dgnc_neo.c
@@ -840,8 +840,7 @@ static void neo_param(struct tty_struct *tty)
 	 */
 	if ((ch->ch_digi.digi_flags & CTSPACE) || (ch->ch_digi.digi_flags & RTSPACE) ||
 		(ch->ch_c_cflag & CRTSCTS) || !(ch->ch_digi.digi_flags & DIGI_FORCEDCD) ||
-		!(ch->ch_c_cflag & CLOCAL))
-	{
+		!(ch->ch_c_cflag & CLOCAL)) {
 		ier |= UART_IER_MSI;
 	} else {
 		ier &= ~UART_IER_MSI;
-- 
1.7.9.5


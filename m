Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbaCZT63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 15:58:29 -0400
Received: from ms-10.1blu.de ([178.254.4.101]:57044 "EHLO ms-10.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070AbaCZT6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 15:58:19 -0400
From: Jonas Hahnfeld <hahnjo@hahnjo.de>
To: acho@novell.com, gregkh@linuxfoundation.org, rashika.kheria@gmail.com,
        peter.p.waskiewicz.jr@intel.com, of82ecuq@cip.cs.fau.de,
        laura.lawniczak@googlemail.com, amarjargal16@gmail.com,
        himangi774@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Jonas Hahnfeld <hahnjo@hahnjo.de>
Subject: [PATCH] staging: keucr: Fix warning about missing blank lines after declarations
Date: Wed, 26 Mar 2014 20:56:53 +0100
Message-Id: <1395863813-11596-1-git-send-email-hahnjo@hahnjo.de>
X-Mailer: git-send-email 1.9.1
X-Con-Id: 154395
X-Con-U: 0-hahnjo
X-Originating-IP: 79.233.135.189
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches fixes two warnings of checkpatch.pl, both of the type
WARNING: Missing a blank line after declarations

Signed-off-by: Jonas Hahnfeld <hahnjo@hahnjo.de>
---
 drivers/staging/keucr/smilsub.c   | 1 +
 drivers/staging/keucr/transport.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/staging/keucr/smilsub.c b/drivers/staging/keucr/smilsub.c
index 44ced82..e981f14 100644
--- a/drivers/staging/keucr/smilsub.c
+++ b/drivers/staging/keucr/smilsub.c
@@ -133,6 +133,7 @@ void Set_D_LogBlockAddr(u8 *redundant)
 void Set_D_FailBlock(u8 *redundant)
 {
 	char i;
+
 	for (i = 0; i < REDTSIZE; i++)
 		*redundant++ = (u8)((i == REDT_BLOCK) ? 0xF0 : 0xFF);
 }
diff --git a/drivers/staging/keucr/transport.c b/drivers/staging/keucr/transport.c
index ae94147..5e59525 100644
--- a/drivers/staging/keucr/transport.c
+++ b/drivers/staging/keucr/transport.c
@@ -669,6 +669,7 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 	/*  R/W data */
 	if (transfer_length) {
 		unsigned int pipe;
+
 		if (srb->sc_data_direction == DMA_FROM_DEVICE)
 			pipe = us->recv_bulk_pipe;
 		else
-- 
1.9.1


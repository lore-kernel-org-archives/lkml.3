Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbaAFOFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:05:25 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:53537 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaAFOFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:05:24 -0500
From: Morgan Creekmore <gamingrobot@gmail.com>
To: gamingrobot@gmail.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: rts5139: Fixed style issues
Date: Mon,  6 Jan 2014 07:05:09 -0700
Message-Id: <1389017109-16032-1-git-send-email-gamingrobot@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed style issues for lines over 80 chars

Signed-off-by: Morgan Creekmore <gamingrobot@gmail.com>
---
 drivers/staging/rts5139/rts51x_card.c | 10 +++++-----
 drivers/staging/rts5139/rts51x_card.h |  8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rts5139/rts51x_card.c b/drivers/staging/rts5139/rts51x_card.c
index 509d83e..03456d9 100644
--- a/drivers/staging/rts5139/rts51x_card.c
+++ b/drivers/staging/rts5139/rts51x_card.c
@@ -373,7 +373,7 @@ void rts51x_release_cards(struct rts51x_chip *chip)
 
 static inline u8 double_depth(u8 depth)
 {
-	return ((depth > 1) ? (depth - 1) : depth);
+	return (depth > 1) ? (depth - 1) : depth;
 }
 
 int rts51x_switch_ssc_clock(struct rts51x_chip *chip, int clk)
@@ -653,8 +653,8 @@ int rts51x_switch_normal_clock(struct rts51x_chip *chip, int clk)
 	return STATUS_SUCCESS;
 }
 
-int rts51x_card_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 sec_addr,
-	    u16 sec_cnt)
+int rts51x_card_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip,
+		u32 sec_addr, u16 sec_cnt)
 {
 	int retval;
 	unsigned int lun = SCSI_LUN(srb);
@@ -770,8 +770,8 @@ void rts51x_eject_card(struct rts51x_chip *chip, unsigned int lun)
 			      XD_INT | MS_INT | SD_INT);
 }
 
-void rts51x_trans_dma_enable(enum dma_data_direction dir, struct rts51x_chip *chip,
-		      u32 byte_cnt, u8 pack_size)
+void rts51x_trans_dma_enable(enum dma_data_direction dir,
+		struct rts51x_chip *chip, u32 byte_cnt, u8 pack_size)
 {
 	if (pack_size > DMA_1024)
 		pack_size = DMA_512;
diff --git a/drivers/staging/rts5139/rts51x_card.h b/drivers/staging/rts5139/rts51x_card.h
index e62b25c..df8816e 100644
--- a/drivers/staging/rts5139/rts51x_card.h
+++ b/drivers/staging/rts5139/rts51x_card.h
@@ -743,13 +743,13 @@ void rts51x_init_cards(struct rts51x_chip *chip);
 void rts51x_release_cards(struct rts51x_chip *chip);
 int rts51x_switch_ssc_clock(struct rts51x_chip *chip, int clk);
 int rts51x_switch_normal_clock(struct rts51x_chip *chip, int clk);
-int rts51x_card_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip, u32 sec_addr,
-	    u16 sec_cnt);
+int rts51x_card_rw(struct scsi_cmnd *srb, struct rts51x_chip *chip,
+		u32 sec_addr, u16 sec_cnt);
 u8 rts51x_get_lun_card(struct rts51x_chip *chip, unsigned int lun);
 int rts51x_select_card(struct rts51x_chip *chip, int card);
 void rts51x_eject_card(struct rts51x_chip *chip, unsigned int lun);
-void rts51x_trans_dma_enable(enum dma_data_direction dir, struct rts51x_chip *chip,
-		      u32 byte_cnt, u8 pack_size);
+void rts51x_trans_dma_enable(enum dma_data_direction dir,
+		struct rts51x_chip *chip, u32 byte_cnt, u8 pack_size);
 int rts51x_enable_card_clock(struct rts51x_chip *chip, u8 card);
 int rts51x_card_power_on(struct rts51x_chip *chip, u8 card);
 int rts51x_toggle_gpio(struct rts51x_chip *chip, u8 gpio);
-- 
1.8.3.2


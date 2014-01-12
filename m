Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaALSuo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:50:44 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:41922 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaALSul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:50:41 -0500
From: Morgan Creekmore <morgan.creekmore@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Morgan Creekmore <morgan.creekmore@gmail.com>
Subject: [PATCH v2] Staging: rts5139: rts51x_card: fixed style issues
Date: Sun, 12 Jan 2014 11:50:12 -0700
Message-Id: <1389552612-19670-1-git-send-email-morgan.creekmore@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed coding style issues, long lines and
extra parentheses on return statement

Signed-off-by: Morgan Creekmore <morgan.creekmore@gmail.com>
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


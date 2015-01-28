Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbbA2BaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:30:17 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40576 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbbA2BaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:30:08 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: vino: vino: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:47:45 +0100
Message-Id: <1422485265-11231-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/media/vino/vino.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/media/vino/vino.c b/drivers/staging/media/vino/vino.c
index 2c85357..f43c1ea 100644
--- a/drivers/staging/media/vino/vino.c
+++ b/drivers/staging/media/vino/vino.c
@@ -2375,7 +2375,6 @@ static irqreturn_t vino_interrupt(int irq, void *dev_id)
 		next_4_desc = vino->a.next_4_desc;
 	unsigned int line_count_2,
 		page_index_2,
-		field_counter_2,
 		start_desc_tbl_2,
 		next_4_desc_2;
 #endif
@@ -2421,7 +2420,6 @@ static irqreturn_t vino_interrupt(int irq, void *dev_id)
 #ifdef VINO_DEBUG_INT
 			line_count_2 = vino->a.line_count;
 			page_index_2 = vino->a.page_index;
-			field_counter_2 = vino->a.field_counter;
 			start_desc_tbl_2 = vino->a.start_desc_tbl;
 			next_4_desc_2 = vino->a.next_4_desc;
 
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab3JWKe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:34:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45323 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750974Ab3JWKe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:34:56 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: hare@suse.de, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [SCSI] aic7xxx: remove duplicate define
Date: Wed, 23 Oct 2013 12:34:43 +0200
Message-Id: <1382524483-3167-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate define
in drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h b/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
index 9df9e2c..8373447 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
@@ -209,7 +209,6 @@ struct instruction {
 #define AIC_OP_JC16	0x9105
 #define AIC_OP_JNC16	0x9205
 #define AIC_OP_CALL16	0x9305
-#define AIC_OP_CALL16	0x9305
 
 /* Page extension is low three bits of second opcode byte. */
 #define AIC_OP_JMPF	0xA005
-- 
1.8.1.2


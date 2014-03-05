Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaCEFSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 00:18:50 -0500
Received: from top.free-electrons.com ([176.31.233.9]:46292 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750747AbaCEFSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 00:18:48 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [RESEND] [SCSI] aic7xxx: remove duplicate define
Date: Wed,  5 Mar 2014 06:18:36 +0100
Message-Id: <1393996716-3670-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386582956-4942-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1386582956-4942-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate define
in drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Acked-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h b/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
index 9df9e2ce3538..8373447bd7d3 100644
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
1.8.3.2


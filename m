Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaCRIYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:24:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34463 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753956AbaCRIX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:23:59 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: akpm@linux-foundation.org, hare@suse.de, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [RESEND] [SCSI] aic7xxx: remove duplicate define
Date: Tue, 18 Mar 2014 09:23:46 +0100
Message-Id: <1395131026-18099-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393996716-3670-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1393996716-3670-1-git-send-email-michael.opdenacker@free-electrons.com>
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


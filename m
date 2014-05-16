Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbaEPNjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:39:06 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:43469 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbaEPNjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:39:01 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 12/49] media: davinci: vpif_display: drop unused member fbuffers
Date: Fri, 16 May 2014 19:03:17 +0530
Message-Id: <1400247235-31434-14-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index 18c7bd5..b22bb33 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -67,9 +67,6 @@ struct vpif_disp_buffer {
 };
 
 struct common_obj {
-	/* Buffer specific parameters */
-	u8 *fbuffers[VIDEO_MAX_FRAME];		/* List of buffer pointers for
-						 * storing frames */
 	u32 numbuffers;				/* number of buffers */
 	struct vpif_disp_buffer *cur_frm;	/* Pointer pointing to current
 						 * vb2_buffer */
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736AbaJ2MDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:03:05 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:46213 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479AbaJ2MDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:03:03 -0400
From: Brian Vandre <bvandre@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gummerer <t.gummerer@gmail.com>,
        Vitor Braga <vitorpybraga@gmail.com>, Lubomir Rintel <lkundrak@v3.sk>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Brian Vandre <bvandre@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: xgifb: fix space before comma
Date: Wed, 29 Oct 2014 07:02:23 -0500
Message-Id: <1414584143-16634-1-git-send-email-bvandre@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the checkpatch.pl error:
ERROR: space prohibited before that ','

Signed-off-by: Brian Vandre <bvandre@gmail.com>
---
 drivers/staging/xgifb/XGI_main_26.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index be7778b..709d49e 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2012,7 +2012,7 @@ static int xgifb_probe(struct pci_dev *pdev,
 	XGIfb_get_fix(&fb_info->fix, -1, fb_info);
 	fb_info->pseudo_palette = xgifb_info->pseudo_palette;
 
-	fb_alloc_cmap(&fb_info->cmap, 256 , 0);
+	fb_alloc_cmap(&fb_info->cmap, 256, 0);
 
 #ifdef CONFIG_MTRR
 	xgifb_info->mtrr = mtrr_add(xgifb_info->video_base,
-- 
1.9.1


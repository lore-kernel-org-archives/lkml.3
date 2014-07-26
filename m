Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaGZMuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 08:50:09 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:53322 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaGZMuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 08:50:07 -0400
From: Mostyn Bramley-Moore <mbmcode@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Mostyn Bramley-Moore <mbmcode@gmail.com>
Subject: [PATCH] staging: netlogic: coding style fixup
Date: Sat, 26 Jul 2014 14:49:58 +0200
Message-Id: <1406378998-19838-1-git-send-email-mbmcode@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary return at end of a void function.
Part of the eudyptula challenge: http://eudyptula-challenge.org/

Signed-off-by: Mostyn Bramley-Moore <mbmcode@gmail.com>
---
 drivers/staging/netlogic/xlr_net.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/netlogic/xlr_net.c b/drivers/staging/netlogic/xlr_net.c
index e320d6b..9bf407d 100644
--- a/drivers/staging/netlogic/xlr_net.c
+++ b/drivers/staging/netlogic/xlr_net.c
@@ -185,7 +185,6 @@ static void xlr_net_fmn_handler(int bkt, int src_stnid, int size,
 		if (skb_new)
 			send_to_rfr_fifo(priv, skb_new->data);
 	}
-	return;
 }
 
 /* Ethtool operation */
-- 
1.9.1


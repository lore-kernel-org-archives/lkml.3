Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbaDTJt7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 05:49:59 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:53879
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754793AbaDTJtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 05:49:46 -0400
X-IronPort-AV: E=Sophos;i="4.97,891,1389740400"; 
   d="scan'208";a="57951925"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Karsten Keil <isdn@linux-pingi.de>
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] hisax/icc: add missing semicolon after label
Date: Sun, 20 Apr 2014 11:48:33 +0200
Message-Id: <1397987313-27579-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

A label just before a brace needs a following semicolon (empty statement).

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/isdn/hisax/icc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hisax/icc.c b/drivers/isdn/hisax/icc.c
index 51dae91..96d1df0 100644
--- a/drivers/isdn/hisax/icc.c
+++ b/drivers/isdn/hisax/icc.c
@@ -425,7 +425,7 @@ afterXPR:
 				if (cs->debug & L1_DEB_MONITOR)
 					debugl1(cs, "ICC %02x -> MOX1", cs->dc.icc.mon_tx[cs->dc.icc.mon_txp - 1]);
 			}
-		AfterMOX1:
+		AfterMOX1: ;
 #endif
 		}
 	}


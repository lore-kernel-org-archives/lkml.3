Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaLGTby (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 14:31:54 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:3226 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424AbaLGT0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 14:26:45 -0500
X-IronPort-AV: E=Sophos;i="5.07,534,1413237600"; 
   d="scan'208";a="111932930"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: kernel-janitors@vger.kernel.org, linux@rasmusvillemoes.dk, joe@perches.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/20] dmfe: fix misspelling of current function in string
Date: Sun,  7 Dec 2014 20:20:46 +0100
Message-Id: <1417980062-25151-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function name contains cleanup, not clean.

This was done using Coccinelle, including the use of Levenshtein distance,
as proposed by Rasmus Villemoes.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The semantic patch is difficult to summarize, but is available in the cover
letter of this patch series.

 drivers/net/ethernet/dec/tulip/dmfe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/dec/tulip/dmfe.c b/drivers/net/ethernet/dec/tulip/dmfe.c
index c820560..50a0077 100644
--- a/drivers/net/ethernet/dec/tulip/dmfe.c
+++ b/drivers/net/ethernet/dec/tulip/dmfe.c
@@ -2265,7 +2265,7 @@ static int __init dmfe_init_module(void)
 
 static void __exit dmfe_cleanup_module(void)
 {
-	DMFE_DBUG(0, "dmfe_clean_module() ", debug);
+	DMFE_DBUG(0, "dmfe_cleanup_module() ", debug);
 	pci_unregister_driver(&dmfe_driver);
 }
 


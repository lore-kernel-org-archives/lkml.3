Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbaLGVAD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 16:00:03 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:26062
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240AbaLGVAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 16:00:00 -0500
X-IronPort-AV: E=Sophos;i="5.07,534,1413237600"; 
   d="scan'208";a="92296987"
Date: Sun, 7 Dec 2014 21:59:56 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Grant Grundler <grantgrundler@gmail.com>
cc: Grant Grundler <grundler@parisc-linux.org>,
        kernel-janitors@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>, joe@perches.com,
        "open list:TULIP NETWORK DRI..." <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/20 v2] uli526x: fix misspelling of current function in
 string
In-Reply-To: <CAP6odjh4Gnc0uAcPTsUMFPTRj7=NYZvMgmL=Rre_kCNah+YcNg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1412072158040.2235@localhost6.localdomain6>
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr> <1417980062-25151-11-git-send-email-Julia.Lawall@lip6.fr> <CAP6odjh4Gnc0uAcPTsUMFPTRj7=NYZvMgmL=Rre_kCNah+YcNg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is named uli526x_cleanup_module, rather than uli526x_clean_module.

This was done using Coccinelle, including the use of Levenshtein distance,
as proposed by Rasmus Villemoes.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Acked-by: Grant Grundler <grantgrundler@gmail.com>

---
v2: fixed commit message

The semantic patch is difficult to summarize, but is available in the cover
letter of this patch series.

 drivers/net/ethernet/dec/tulip/uli526x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/dec/tulip/uli526x.c b/drivers/net/ethernet/dec/tulip/uli526x.c
index 4061f9b..1c5916b 100644
--- a/drivers/net/ethernet/dec/tulip/uli526x.c
+++ b/drivers/net/ethernet/dec/tulip/uli526x.c
@@ -1837,7 +1837,7 @@ static int __init uli526x_init_module(void)
 
 static void __exit uli526x_cleanup_module(void)
 {
-	ULI526X_DBUG(0, "uli526x_clean_module() ", debug);
+	ULI526X_DBUG(0, "uli526x_cleanup_module() ", debug);
 	pci_unregister_driver(&uli526x_driver);
 }
 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab3GIPVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:21:35 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:57605 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752873Ab3GIPVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:21:31 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14afh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1155h)
From: Cristian Bercaru <cristian.bercaru@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: Cristian Bercaru <cristian.bercaru@freescale.com>, <cocci@systeme.lip6.fr>
Subject: [PATCH] invoke arguments the right way in coccinelle script
Date: Tue, 9 Jul 2013 18:21:18 +0300
Message-ID: <1373383278-3339-1-git-send-email-cristian.bercaru@freescale.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the command line arguments were invoked incorrectly
'make coccicheck' failed to run 'irqf_oneshot.cocci' and all tests that
followed. Fixed that.

Signed-off-by: Cristian Bercaru <cristian.bercaru@freescale.com>
---
 scripts/coccinelle/misc/irqf_oneshot.cocci | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/coccinelle/misc/irqf_oneshot.cocci b/scripts/coccinelle/misc/irqf_oneshot.cocci
index 6cfde94..5cca680 100644
--- a/scripts/coccinelle/misc/irqf_oneshot.cocci
+++ b/scripts/coccinelle/misc/irqf_oneshot.cocci
@@ -4,7 +4,7 @@
 //
 // Confidence: Good
 // Comments:
-// Options: --no-includes
+// Options: -no_includes
 
 virtual patch
 virtual context
-- 
1.7.11.7



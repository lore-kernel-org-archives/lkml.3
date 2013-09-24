Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab3IXVLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:11:20 -0400
Received: from smtprelay0033.hostedemail.com ([216.40.44.33]:45181 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754071Ab3IXVKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:10:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3870:3871:4384:5007:6261:6691:7903:10004:10026:10848:11657:11658:11914:12043:12294:12296:12438:12517:12519:12555:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: drain01_6a345c7d4a45
X-Filterd-Recvd-Size: 3051
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] fddi/skfp: Remove extern from function prototypes
Date: Tue, 24 Sep 2013 14:10:03 -0700
Message-Id: <d140ad96146b6e7b196c31cbbb0f971845bfd053.1380056108.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1380056108.git.joe@perches.com>
References: <cover.1380056108.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a mix of function prototypes with and without extern
in the kernel sources.  Standardize on not using extern for
function prototypes.

Function prototypes don't need to be written with extern.
extern is assumed by the compiler.  Its use is as unnecessary as
using auto to declare automatic/local variables in a block.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/fddi/skfp/h/smc.h | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/fddi/skfp/h/smc.h b/drivers/net/fddi/skfp/h/smc.h
index 3ca308b..bd1166b 100644
--- a/drivers/net/fddi/skfp/h/smc.h
+++ b/drivers/net/fddi/skfp/h/smc.h
@@ -469,20 +469,20 @@ struct s_smc {
 
 extern const struct fddi_addr fddi_broadcast;
 
-extern void all_selection_criteria(struct s_smc *smc);
-extern void card_stop(struct s_smc *smc);
-extern void init_board(struct s_smc *smc, u_char *mac_addr);
-extern int init_fplus(struct s_smc *smc);
-extern void init_plc(struct s_smc *smc);
-extern int init_smt(struct s_smc *smc, u_char * mac_addr);
-extern void mac1_irq(struct s_smc *smc, u_short stu, u_short stl);
-extern void mac2_irq(struct s_smc *smc, u_short code_s2u, u_short code_s2l);
-extern void mac3_irq(struct s_smc *smc, u_short code_s3u, u_short code_s3l);
-extern int pcm_status_twisted(struct s_smc *smc);
-extern void plc1_irq(struct s_smc *smc);
-extern void plc2_irq(struct s_smc *smc);
-extern void read_address(struct s_smc *smc, u_char * mac_addr);
-extern void timer_irq(struct s_smc *smc);
+void all_selection_criteria(struct s_smc *smc);
+void card_stop(struct s_smc *smc);
+void init_board(struct s_smc *smc, u_char *mac_addr);
+int init_fplus(struct s_smc *smc);
+void init_plc(struct s_smc *smc);
+int init_smt(struct s_smc *smc, u_char *mac_addr);
+void mac1_irq(struct s_smc *smc, u_short stu, u_short stl);
+void mac2_irq(struct s_smc *smc, u_short code_s2u, u_short code_s2l);
+void mac3_irq(struct s_smc *smc, u_short code_s3u, u_short code_s3l);
+int pcm_status_twisted(struct s_smc *smc);
+void plc1_irq(struct s_smc *smc);
+void plc2_irq(struct s_smc *smc);
+void read_address(struct s_smc *smc, u_char *mac_addr);
+void timer_irq(struct s_smc *smc);
 
 #endif	/* _SCMECM_ */
 
-- 
1.8.1.2.459.gbcd45b4.dirty


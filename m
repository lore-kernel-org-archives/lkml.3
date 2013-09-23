Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab3IWShp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:37:45 -0400
Received: from smtprelay0200.hostedemail.com ([216.40.44.200]:48539 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754220Ab3IWShn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:37:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1540:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:5007:6261:7903:10004:10026:10848:11026:11473:11658:11914:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jump89_433c2511cb51b
X-Filterd-Recvd-Size: 1729
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
Subject: [PATCH 09/12] caif_hsi.h: Remove extern from function prototypes
Date: Mon, 23 Sep 2013 11:37:40 -0700
Message-Id: <40537362e8ba86fa727226ddfeb75c205c63ecaf.1379961014.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <445209f8885ccd8234fa787c30d63e63fc7917d7.1379961014.git.joe@perches.com>
References: <445209f8885ccd8234fa787c30d63e63fc7917d7.1379961014.git.joe@perches.com>
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
 include/net/caif/caif_hsi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/caif/caif_hsi.h b/include/net/caif/caif_hsi.h
index 4795e81..097f69c 100644
--- a/include/net/caif/caif_hsi.h
+++ b/include/net/caif/caif_hsi.h
@@ -195,6 +195,6 @@ enum ifla_caif_hsi {
 	__IFLA_CAIF_HSI_MAX
 };
 
-extern struct cfhsi_ops *cfhsi_get_ops(void);
+struct cfhsi_ops *cfhsi_get_ops(void);
 
 #endif		/* CAIF_HSI_H_ */
-- 
1.8.1.2.459.gbcd45b4.dirty


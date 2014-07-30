Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbaG3Dje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:39:34 -0400
Received: from smtprelay0038.hostedemail.com ([216.40.44.38]:54342 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754957AbaG3Di6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:38:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1540:1568:1711:1714:1730:1747:1777:1792:2393:2559:2562:2895:3138:3139:3140:3141:3142:3865:3870:5007:6261:7514:10004:10026:10848:11232:11658:11914:12043:12517:12519:12555:13311:13357:14096:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: war03_4e28c18e1475f
X-Filterd-Recvd-Size: 1533
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] MAINTAINERS: Update samsung pinctrl patterns
Date: Tue, 29 Jul 2014 20:38:43 -0700
Message-Id: <c572d2afabb69f113f616154c87eef2b013a8897.1406691397.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1406691397.git.joe@perches.com>
References: <cover.1406691397.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ebe629a39e04 ("pinctrl: samsung: Group all drivers in a sub-dir")
moved the files, update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8ed337c..70f157e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6989,9 +6989,7 @@ M:	Thomas Abraham <thomas.abraham@linaro.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 S:	Maintained
-F:	drivers/pinctrl/pinctrl-exynos.*
-F:	drivers/pinctrl/pinctrl-s3c*
-F:	drivers/pinctrl/pinctrl-samsung.*
+F:	drivers/pinctrl/samsung/
 
 PIN CONTROLLER - ST SPEAR
 M:	Viresh Kumar <viresh.linux@gmail.com>
-- 
1.8.1.2.459.gbcd45b4.dirty


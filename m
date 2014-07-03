Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965062AbaGCWIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:08:36 -0400
Received: from smtprelay0175.hostedemail.com ([216.40.44.175]:33619 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964867AbaGCWId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:08:33 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1534:1539:1566:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3865:3874:4250:4321:5007:6120:6261:7901:10004:10026:10848:11232:11657:11658:11914:12043:12517:12519:12555:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: humor14_2d621e40a9c40
X-Filterd-Recvd-Size: 1439
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 14/16] MAINTAINERS: Remove unusd ARM/QUALCOMM MSM pattern
Date: Thu,  3 Jul 2014 15:07:58 -0700
Message-Id: <82f26119384a5cd53032738424498aa79f942b75.1404425176.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1404425176.git.joe@perches.com>
References: <cover.1404425176.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 87933a68dce6 ("mfd: pm8921: Remove pm8xxx API now that sub-devices
use regmap") removed the file, remove the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Stephen Boyd <sboyd@codeaurora.org>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 09b4a67..b7e3a32 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1144,7 +1144,6 @@ F:	drivers/tty/serial/msm_serial.h
 F:	drivers/tty/serial/msm_serial.c
 F:	drivers/*/pm8???-*
 F:	drivers/mfd/ssbi.c
-F:	include/linux/mfd/pm8xxx/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git
 S:	Maintained
 
-- 
1.8.1.2.459.gbcd45b4.dirty


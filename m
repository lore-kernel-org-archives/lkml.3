Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaJOTcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:32:16 -0400
Received: from smtprelay0060.hostedemail.com ([216.40.44.60]:54934 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751020AbaJOTcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:32:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:973:982:988:989:1260:1345:1437:1537:1561:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3866:5007:6114:6261:6642:10004:10848:11658:11914:12043:12291:12517:12519:12663:12679:12683:13311:13357:14095:14110:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: week38_4da2a0457f85d
X-Filterd-Recvd-Size: 910
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] checkpatch: Miscellaneous cleanups
Date: Wed, 15 Oct 2014 12:32:06 -0700
Message-Id: <cover.1413400022.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2.443.g670a3c1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (3):
  checkpatch: Add an error test for no space before comma
  checkpatch: Add error on use of attribute((weak)) or __weak
  checkpatch: Improve test for no space after cast

 scripts/checkpatch.pl | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

-- 
2.1.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab3LZTUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 14:20:36 -0500
Received: from smtprelay0023.hostedemail.com ([216.40.44.23]:36854 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753611Ab3LZTUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 14:20:35 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:152:355:379:541:982:988:989:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1538:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2895:3138:3139:3140:3141:3142:3865:5007:6119:6261:10004:10026:10400:10848:11658:11914:12043:12291:12517:12519:12663:12679:12683:13069:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mom62_5c1c37c74ef40
X-Filterd-Recvd-Size: 1225
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] checkpatch: A few corrections and updates
Date: Thu, 26 Dec 2013 11:20:27 -0800
Message-Id: <cover.1388085015.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (5):
  checkpatch: Add tests for function pointer style misuses
  checkpatch: Add a --fix-inplace option
  checkpatch: Improve space before tab --fix option
  checkpatch: check for if's with unnecessary parentheses
  checkpatch: Update the FSF/GPL address check

 scripts/checkpatch.pl | 100 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 92 insertions(+), 8 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty


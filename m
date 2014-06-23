Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbaFWQf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:35:59 -0400
Received: from smtprelay0167.hostedemail.com ([216.40.44.167]:60940 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756268AbaFWQf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:35:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:982:988:989:1260:1345:1437:1534:1538:1566:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3867:5007:6261:6642:10004:10026:10848:11658:11914:12043:12291:12517:12519:12679:12683:13095:13311:13357:14095:14110,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bath57_33dc9220b5f12
X-Filterd-Recvd-Size: 1131
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jean Delvare <jdelvare@suse.de>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] checkpatch: Line spacing tests and Kconfig help
Date: Mon, 23 Jun 2014 09:35:51 -0700
Message-Id: <cover.1403541113.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some vertical spacing tests.
Quiet Kconfig help false positives.

Joe Perches (4):
  checkpatch: Add test for blank lines after function/struct/union/enum
  checkpatch: Add a multiple blank lines test
  checkpatch: Change blank line after declaration type to "LINE_SPACING"
  checkpatch: Quiet Kconfig help message checking

 scripts/checkpatch.pl | 35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty


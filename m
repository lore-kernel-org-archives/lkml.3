Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaGJSxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:53:47 -0400
Received: from smtprelay0029.hostedemail.com ([216.40.44.29]:39381 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750877AbaGJSxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:53:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:982:988:989:1260:1345:1437:1534:1538:1566:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3865:3866:3868:5007:6261:10004:10026:10848:11026:11658:11914:12043:12291:12296:12517:12519:12679:12683:13311:13357:14095:14110:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crown08_3daa362b6d512
X-Filterd-Recvd-Size: 1104
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] checkpatch: More --fix insert/delete lines for BRACES
Date: Thu, 10 Jul 2014 11:53:37 -0700
Message-Id: <cover.1405018255.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bit of neatening and add a few patch/file corrections for
misplaced braces

Joe Perches (4):
  checkpatch: Add fix_insert_line and fix_delete_line helpers
  checkpatch: Use the correct indentation for which()
  checkpatch: Add --fix option for a couple OPEN_BRACE misuses
  checkpatch: Fix brace style misuses of else and while

 scripts/checkpatch.pl | 148 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 93 insertions(+), 55 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty


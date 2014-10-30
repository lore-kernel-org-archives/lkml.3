Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbaJ3SMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 14:12:01 -0400
Received: from smtprelay0071.hostedemail.com ([216.40.44.71]:35409 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758593AbaJ3SL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 14:11:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:968:988:989:1260:1345:1534:1538:1561:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3866:4605:5007:6114:6261:6642:10004:10848:11658:11914:12043:12296:12517:12519:12679:12683:13311:13357:14110:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: drain01_686983195f963
X-Filterd-Recvd-Size: 1026
From: Joe Perches <joe@perches.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Remove use of early_vprintk, tile neatening
Date: Thu, 30 Oct 2014 11:11:51 -0700
Message-Id: <cover.1414691783.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (3):
  printk: Remove used-once early_vprintk
  tile: Neaten early_printk uses
  tile: Use pr_warn instead of pr_warning

 arch/tile/kernel/early_printk.c | 19 +++++++++++------
 arch/tile/kernel/setup.c        | 45 ++++++++++++++++++-----------------------
 include/linux/printk.h          |  1 -
 kernel/printk/printk.c          | 19 ++++++++---------
 4 files changed, 41 insertions(+), 43 deletions(-)

-- 
2.1.2


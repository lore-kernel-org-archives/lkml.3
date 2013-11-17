Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab3KQJzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 04:55:19 -0500
Received: from smtprelay0192.hostedemail.com ([216.40.44.192]:60974 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751850Ab3KQJzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 04:55:16 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:960:988:989:1260:1345:1534:1538:1561:1711:1714:1730:1747:1777:1792:2393:2559:2562:2904:3138:3139:3140:3141:3142:3865:3867:3870:3872:4605:5007:6119:6261:7903:10004:10026:10848:11026:11658:11914:12043:12291:12517:12519:12679:12683:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fruit93_10a8851c5961b
X-Filterd-Recvd-Size: 1030
From: Joe Perches <joe@perches.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] softirq: possible speedup and neatenings
Date: Sun, 17 Nov 2013 01:55:09 -0800
Message-Id: <cover.1384656563.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first one boots, but it's barely tested.

Joe Perches (3):
  softirq: Use ffs in __do_softirq
  softirq: Convert printks to pr_<level>
  softirq: Use const char * const for softirq_to_name, whitespace neatening

 include/linux/interrupt.h |  2 +-
 kernel/softirq.c          | 75 +++++++++++++++++++++--------------------------
 2 files changed, 35 insertions(+), 42 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty


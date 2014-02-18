Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbaBRRmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:42:51 -0500
Received: from smtprelay0113.hostedemail.com ([216.40.44.113]:58909 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753464AbaBRRmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:42:49 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:69:355:379:541:968:973:988:989:1260:1345:1537:1560:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3866:5007:6114:6261:6312:6642:10004:10026:10848:11026:11658:11914:12043:12517:12519:12679:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: slope87_3586fd7f83955
X-Filterd-Recvd-Size: 925
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] bonding: More ether_addr_copy and neatenings.
Date: Tue, 18 Feb 2014 09:42:44 -0800
Message-Id: <cover.1392745013.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (3):
  bonding: More use of ether_addr_copy
  bonding: Remove unnecessary else
  bonding: Invert test

 drivers/net/bonding/bond_3ad.c  | 21 ++++++++++-----------
 drivers/net/bonding/bond_alb.c  | 17 ++++++++---------
 drivers/net/bonding/bond_main.c |  6 +++---
 3 files changed, 21 insertions(+), 23 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty


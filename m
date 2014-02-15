Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaBOX5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 18:57:19 -0500
Received: from smtprelay0235.hostedemail.com ([216.40.44.235]:38936 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751800AbaBOX5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 18:57:17 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:69:355:379:541:960:973:988:989:1260:1345:1534:1540:1568:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3867:5007:6261:6642:10004:10026:10848:11026:11658:11914:12043:12296:12517:12519:12679:12683:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: van03_5c338b1acb61a
X-Filterd-Recvd-Size: 1333
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/4] bonding cleaning
Date: Sat, 15 Feb 2014 15:57:03 -0800
Message-Id: <cover.1392508410.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miscellaneous cleanups

Joe Perches (4):
  bonding: Convert pr_warning to pr_warn, neatening
  bonding: Neaten pr_<level>
  bonding: Convert c99 comments
  bonding: Convert memcpy(foo, bar, ETH_ALEN) to ether_addr_copy(foo, bar)

 drivers/net/bonding/bond_3ad.c     |  19 +--
 drivers/net/bonding/bond_3ad.h     | 175 ++++++++++++++--------------
 drivers/net/bonding/bond_alb.c     |  36 +++---
 drivers/net/bonding/bond_debugfs.c |  10 +-
 drivers/net/bonding/bond_main.c    | 231 ++++++++++++++++++-------------------
 drivers/net/bonding/bond_netlink.c |   6 +-
 drivers/net/bonding/bond_options.c | 102 ++++++++--------
 drivers/net/bonding/bond_procfs.c  |   8 +-
 drivers/net/bonding/bond_sysfs.c   |   8 +-
 9 files changed, 288 insertions(+), 307 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty


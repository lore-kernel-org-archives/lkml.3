Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaIJERk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:17:40 -0400
Received: from smtprelay0120.hostedemail.com ([216.40.44.120]:35622 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751105AbaIJERj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:17:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:69:355:379:541:968:973:988:989:1260:1345:1534:1541:1711:1714:1730:1747:1777:1792:1801:2393:2559:2562:3138:3139:3140:3141:3142:3351:3866:3867:3870:4419:4605:5007:6261:6742:10004:10026:10848:11026:11658:11914:12043:12296:12517:12519:12679:12683:13095:13311:13357:14095:14096:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tin94_5f6b390190e60
X-Filterd-Recvd-Size: 2067
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Sage Weil <sage@inktank.com>,
        Ursula Braun <ursula.braun@de.ibm.com>, linux390@de.ibm.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-s390@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: [PATCH net-next 0/5] net: Convert pr_warning to pr_warn
Date: Tue,  9 Sep 2014 21:17:27 -0700
Message-Id: <cover.1410322181.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove remaining uses of pr_warning in net/

Joe Perches (5):
  atm: Convert pr_warning to pr_warn
  ceph: Convert pr_warning to pr_warn
  pktgen: Convert pr_warning to pr_warn
  iucv: Convert pr_warning to pr_warn
  netfilter: Convert pr_warning to pr_warn

 net/atm/clip.c                        |  4 ++--
 net/atm/common.c                      |  2 +-
 net/ceph/ceph_common.c                | 15 +++++++++------
 net/ceph/messenger.c                  | 19 +++++++++---------
 net/ceph/osd_client.c                 | 15 +++++++--------
 net/ceph/osdmap.c                     | 20 +++++++++----------
 net/core/pktgen.c                     | 24 +++++++++++------------
 net/iucv/iucv.c                       |  9 ++++-----
 net/netfilter/ipset/ip_set_core.c     | 23 +++++++++++-----------
 net/netfilter/ipset/ip_set_hash_gen.h | 12 ++++++------
 net/netfilter/xt_connbytes.c          |  2 +-
 net/netfilter/xt_hashlimit.c          |  2 +-
 net/netfilter/xt_set.c                | 36 ++++++++++++++++-------------------
 13 files changed, 90 insertions(+), 93 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty


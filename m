Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab3JRUsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 16:48:30 -0400
Received: from smtprelay0185.hostedemail.com ([216.40.44.185]:44279 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754581Ab3JRUs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 16:48:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:968:973:988:989:1260:1345:1437:1534:1541:1711:1730:1747:1777:1792:1801:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:4419:4605:5007:6261:10004:10026:10848:11026:11658:11914:12043:12517:12519:12555:12679:12683:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bulb32_2c8f0851f8e07
X-Filterd-Recvd-Size: 2529
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] net: Remove extern from function prototypes
Date: Fri, 18 Oct 2013 13:48:21 -0700
Message-Id: <cover.1382129045.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the remainder of extern function prototypes from net/.../*.h files.

Joe Perches (4):
  net: 8021q/bluetooth/bridge/can/ceph: Remove extern from function prototypes
  net: dccp: Remove extern from function prototypes
  net: ipv4/ipv6: Remove extern from function prototypes
  net: misc: Remove extern from function prototypes

 net/8021q/vlan.h                    |  28 ++--
 net/bluetooth/hidp/hidp.h           |   4 +-
 net/bridge/br_private.h             | 299 +++++++++++++++++-------------------
 net/bridge/br_private_stp.h         |  24 +--
 net/can/af_can.h                    |   6 +-
 net/ceph/auth_none.h                |   2 +-
 net/ceph/auth_x.h                   |   2 +-
 net/ceph/crypto.h                   |  48 +++---
 net/dccp/ackvec.h                   |  21 ++-
 net/dccp/ccid.h                     |  18 +--
 net/dccp/ccids/lib/loss_interval.h  |   8 +-
 net/dccp/ccids/lib/packet_history.h |  25 ++-
 net/dccp/ccids/lib/tfrc.h           |  22 +--
 net/dccp/dccp.h                     | 186 +++++++++++-----------
 net/dccp/feat.h                     |  26 ++--
 net/ipv4/fib_lookup.h               |  26 ++--
 net/ipv4/tcp_vegas.h                |  10 +-
 net/ipv4/udp_impl.h                 |  36 ++---
 net/ipv6/udp_impl.h                 |  41 +++--
 net/irda/irnet/irnet.h              |  15 +-
 net/l2tp/l2tp_core.h                |  57 ++++---
 net/mac80211/rate.h                 |  12 +-
 net/netfilter/nf_internals.h        |  28 ++--
 net/rds/rds.h                       |   2 +-
 net/rxrpc/ar-internal.h             | 150 +++++++++---------
 net/tipc/core.h                     |  28 ++--
 net/wimax/wimax-internal.h          |  18 +--
 net/wireless/core.h                 |   6 +-
 net/wireless/sysfs.h                |   4 +-
 net/xfrm/xfrm_hash.h                |   4 +-
 30 files changed, 553 insertions(+), 603 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty


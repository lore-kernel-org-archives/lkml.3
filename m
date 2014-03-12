Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbaCLREe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:04:34 -0400
Received: from smtprelay0194.hostedemail.com ([216.40.44.194]:42582 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751168AbaCLREc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:04:32 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:69:355:379:541:960:973:988:989:1260:1345:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3866:3867:4605:5007:6261:6642:10004:10026:10848:11657:11658:11914:12043:12291:12517:12519:12555:12679:12683:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bee71_7e2a837c4194c
X-Filterd-Recvd-Size: 2096
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-zigbee-devel@lists.sourceforge.net,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, tipc-discussion@lists.sourceforge.net
Subject: [PATCH net-next 0/6] net: Convert uses of __constant_<foo> to <foo>
Date: Wed, 12 Mar 2014 10:04:14 -0700
Message-Id: <cover.1394643455.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (6):
  8021q: Convert uses of __constant_<foo> to <foo>
  bluetooth: Convert uses of __constant_<foo> to <foo>
  net: Convert uses of __constant_<foo> to <foo>
  ieee802154: Convert uses of __constant_<foo> to <foo>
  netfilter: Convert uses of __constant_<foo> to <foo>
  tipc: Convert uses of __constant_<foo> to <foo>

 net/8021q/vlan.h               |  4 +-
 net/8021q/vlan_netlink.c       |  4 +-
 net/bluetooth/a2mp.c           |  4 +-
 net/bluetooth/hci_conn.c       | 26 ++++++------
 net/bluetooth/hci_core.c       |  2 +-
 net/bluetooth/hci_event.c      |  6 +--
 net/bluetooth/hci_sock.c       | 16 ++++----
 net/bluetooth/l2cap_core.c     | 90 +++++++++++++++++++++---------------------
 net/bluetooth/l2cap_sock.c     |  6 +--
 net/bluetooth/mgmt.c           | 26 ++++++------
 net/bluetooth/rfcomm/core.c    |  4 +-
 net/bluetooth/sco.c            | 10 ++---
 net/bluetooth/smp.c            |  2 +-
 net/core/dev.c                 | 10 ++---
 net/core/flow_dissector.c      | 14 +++----
 net/ieee802154/6lowpan_rtnl.c  |  2 +-
 net/ieee802154/af_ieee802154.c |  2 +-
 net/netfilter/ipset/pfxlen.c   |  4 +-
 net/netfilter/xt_AUDIT.c       |  4 +-
 net/tipc/bearer.c              |  2 +-
 20 files changed, 119 insertions(+), 119 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab3IZWSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 18:18:47 -0400
Received: from smtprelay0145.hostedemail.com ([216.40.44.145]:35300 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754121Ab3IZWSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 18:18:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:69:355:379:421:541:968:973:988:989:1260:1345:1437:1534:1541:1711:1730:1747:1777:1792:1801:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3867:3870:3873:4321:4605:5007:6261:7264:10004:10026:10848:10967:11026:11658:11914:12043:12438:12517:12519:12555:12679:12683:12740:13161:13229:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: love96_85ee7a8b40550
X-Filterd-Recvd-Size: 2722
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-hippi@sunsite.dk, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH 0/3 - GIT PULL] include/linux: Remove externs from networking function prototypes
Date: Thu, 26 Sep 2013 15:18:30 -0700
Message-Id: <cover.1380233637.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following changes since commit aae8c287e664d49df4aa315ad263c33b9a2af3e1:

  Merge branch 'bonding_neighbours' (2013-09-26 16:02:19 -0400)

are available in the git repository at:

  git://repo.or.cz/linux-2.6/trivial-mods.git 20130926_include_linux_networking_externs

for you to fetch changes up to f629d208d27a22f495b7734eede585b5d207e912:

  [networking]device.h: Remove extern from function prototypes (2013-09-26 15:06:58 -0700)

----------------------------------------------------------------

Joe Perches (3):
  netfilter: Remove extern from function prototypes
  net.h/skbuff.h: Remove extern from function prototypes
  [networking]device.h: Remove extern from function prototypes

 include/linux/etherdevice.h                      |  35 +-
 include/linux/fcdevice.h                         |   2 +-
 include/linux/fddidevice.h                       |   7 +-
 include/linux/hippidevice.h                      |  10 +-
 include/linux/inetdevice.h                       |  28 +-
 include/linux/net.h                              |  82 ++---
 include/linux/netdevice.h                        | 432 +++++++++++------------
 include/linux/netfilter.h                        |  10 +-
 include/linux/netfilter/nf_conntrack_common.h    |   2 +-
 include/linux/netfilter/nf_conntrack_h323.h      |  14 +-
 include/linux/netfilter/nf_conntrack_proto_gre.h |   4 +-
 include/linux/netfilter/nf_conntrack_sip.h       |  57 ++-
 include/linux/netfilter/nfnetlink.h              |  28 +-
 include/linux/netfilter/nfnetlink_acct.h         |   6 +-
 include/linux/netfilter/x_tables.h               | 128 ++++---
 include/linux/netfilter_bridge.h                 |   4 +-
 include/linux/netfilter_ipv4.h                   |   6 +-
 include/linux/netfilter_ipv6.h                   |  10 +-
 include/linux/skbuff.h                           | 250 ++++++-------
 19 files changed, 529 insertions(+), 586 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty


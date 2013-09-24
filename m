Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3IXVKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:10:21 -0400
Received: from smtprelay0114.hostedemail.com ([216.40.44.114]:49145 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754071Ab3IXVKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:10:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:421:541:968:973:988:989:1260:1345:1437:1534:1543:1711:1730:1747:1777:1792:1801:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3867:3870:3873:4321:4605:5007:6261:10004:10026:10848:10967:11658:11914:12043:12438:12517:12519:12555:12679:12683:12740:13161:13229:13255,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sand54_2081d7fc5633
X-Filterd-Recvd-Size: 3999
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, cbe-oss-dev@lists.ozlabs.org
Subject: [PATCH 00/10 - GIT PULL] drivers: net: Next block of Remove extern from function prototypes
Date: Tue, 24 Sep 2013 14:09:54 -0700
Message-Id: <cover.1380056108.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b0983d3c9b132c33b6fb2e28d157a1edc18a173c:

  tcp: fix dynamic right sizing (2013-09-24 11:07:32 -0400)

are available in the git repository at:

  git://repo.or.cz/linux-2.6/trivial-mods.git 20130924_dn_externs_2

for you to fetch changes up to 294da3abaa73a0b69fd54e442b0b5bd9455b7be6:

  irda: Remove extern from function prototypes (2013-09-24 12:54:17 -0700)

----------------------------------------------------------------
Joe Perches (10):
  ibm/emac: Remove extern from function prototypes
  intel: Remove extern from function prototypes
  oki-semi: Remove extern from function prototypes
  qlogic: Remove extern from function prototypes
  sfc: Remove extern from function prototypes
  stmicro: Remove extern from function prototypes
  ti: Remove extern from function prototypes
  toshiba: Remove extern from function prototypes
  fddi/skfp: Remove extern from function prototypes
  irda: Remove extern from function prototypes

 drivers/net/ethernet/ibm/emac/debug.h             |  14 +-
 drivers/net/ethernet/ibm/emac/rgmii.h             |  18 +-
 drivers/net/ethernet/ibm/emac/tah.h               |  14 +-
 drivers/net/ethernet/ibm/emac/zmii.h              |  18 +-
 drivers/net/ethernet/intel/e1000/e1000.h          |  32 ++--
 drivers/net/ethernet/intel/e1000e/e1000.h         |  45 +++--
 drivers/net/ethernet/intel/igb/e1000_82575.h      |  16 +-
 drivers/net/ethernet/intel/igb/e1000_hw.h         |   6 +-
 drivers/net/ethernet/intel/igb/e1000_i210.h       |  38 ++--
 drivers/net/ethernet/intel/igb/e1000_mac.h        |   2 +-
 drivers/net/ethernet/intel/igb/igb.h              |  73 ++++----
 drivers/net/ethernet/intel/igbvf/igbvf.h          |  22 +--
 drivers/net/ethernet/intel/ixgb/ixgb.h            |  22 +--
 drivers/net/ethernet/intel/ixgb/ixgb_hw.h         |  25 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe.h          | 172 +++++++++---------
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h      |  34 ++--
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h   |  56 +++---
 drivers/net/ethernet/qlogic/netxen/netxen_nic.h   |   5 +-
 drivers/net/ethernet/qlogic/qlge/qlge.h           |  58 +++---
 drivers/net/ethernet/sfc/efx.h                    | 104 ++++++-----
 drivers/net/ethernet/sfc/mcdi.h                   | 120 ++++++-------
 drivers/net/ethernet/sfc/mdio_10g.h               |  26 ++-
 drivers/net/ethernet/sfc/nic.h                    | 210 +++++++++++-----------
 drivers/net/ethernet/sfc/phy.h                    |   8 +-
 drivers/net/ethernet/sfc/selftest.h               |  15 +-
 drivers/net/ethernet/stmicro/stmmac/common.h      |  12 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h   |  17 +-
 drivers/net/ethernet/stmicro/stmmac/mmc.h         |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h      |  10 +-
 drivers/net/ethernet/ti/cpts.h                    |   9 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.h      |  29 ++-
 drivers/net/ethernet/toshiba/ps3_gelic_wireless.h |   6 +-
 drivers/net/ethernet/toshiba/spider_net.h         |   4 +-
 drivers/net/fddi/skfp/h/smc.h                     |  28 +--
 drivers/net/irda/sir-dev.h                        |  29 +--
 35 files changed, 631 insertions(+), 672 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty


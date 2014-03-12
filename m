Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbaCLRWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:22:49 -0400
Received: from smtprelay0202.hostedemail.com ([216.40.44.202]:57120 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752668AbaCLRWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:22:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:69:355:379:541:960:973:988:989:1260:1345:1534:1541:1711:1730:1747:1777:1792:1801:2393:2559:2562:3138:3139:3140:3141:3142:3352:3866:3867:4605:5007:6261:6642:10004:10026:10848:11026:11658:11914:12043:12517:12519:12679:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: price82_8c4e6b4a37b37
X-Filterd-Recvd-Size: 2022
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: [PATCH net-next 0/9] drivers/net: Convert uses of __constant_<foo> to <foo>
Date: Wed, 12 Mar 2014 10:22:29 -0700
Message-Id: <cover.1394644825.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (9):
  brocade: Convert uses of __constant_<foo> to <foo>
  e100: Convert uses of __constant_<foo> to <foo>
  igb: Convert uses of __constant_<foo> to <foo>
  igbvf: Convert uses of __constant_<foo> to <foo>
  ixgbe: Convert uses of __constant_<foo> to <foo>
  ixgbevf: Convert uses of __constant_<foo> to <foo>
  xilinx: Convert uses of __constant_<foo> to <foo>
  lg-vl600: Convert uses of __constant_<foo> to <foo>
  ath9k: Convert uses of __constant_<foo> to <foo>

 drivers/net/ethernet/brocade/bna/bnad.c           | 16 +++++-------
 drivers/net/ethernet/intel/e100.c                 |  4 +--
 drivers/net/ethernet/intel/igb/igb_main.c         | 12 ++++-----
 drivers/net/ethernet/intel/igbvf/netdev.c         |  4 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c     |  8 +++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     | 30 +++++++++++------------
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |  4 +--
 drivers/net/ethernet/xilinx/ll_temac_main.c       |  4 +--
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |  2 +-
 drivers/net/usb/lg-vl600.c                        |  2 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c    |  4 +--
 11 files changed, 43 insertions(+), 47 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty


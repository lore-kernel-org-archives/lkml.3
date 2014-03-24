Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbaCXUPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:15:51 -0400
Received: from smtprelay0212.hostedemail.com ([216.40.44.212]:48842 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753671AbaCXUPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:15:49 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:968:973:988:989:1260:1345:1437:1534:1541:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3866:3867:4225:4605:5007:6261:6642:10004:10026:10848:11026:11657:11658:11914:12043:12517:12519:12679:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hook63_1589302484260
X-Filterd-Recvd-Size: 2613
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: nios2-dev@lists.rocketboards.org, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: [PATCH net-next 0/7] drivers/net: Remove pointer casts to same type
Date: Mon, 24 Mar 2014 13:15:33 -0700
Message-Id: <cover.1395692043.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of these are pointless...

Joe Perches (7):
  altera: Remove casts of pointer to same type
  alx: Remove casts of pointer to same type
  intel: Remove casts of pointer to same type
  qlcnic: Remove casts of pointer to same type
  carl9170: Remove casts of pointer to same type
  mwifiex: Remove casts of pointer to same type
  rtlwifi: Remove casts of pointer to same type

 drivers/net/ethernet/altera/altera_tse_main.c      |  4 +-
 drivers/net/ethernet/atheros/alx/main.c            |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  4 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |  2 +-
 drivers/net/wireless/ath/carl9170/rx.c             |  2 +-
 drivers/net/wireless/mwifiex/pcie.c                |  6 +--
 drivers/net/wireless/mwifiex/scan.c                |  2 +-
 drivers/net/wireless/mwifiex/tdls.c                |  6 +--
 drivers/net/wireless/rtlwifi/core.c                |  2 +-
 drivers/net/wireless/rtlwifi/ps.c                  | 19 ++++---
 drivers/net/wireless/rtlwifi/rtl8188ee/dm.c        |  5 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/fw.c        |  4 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c        | 57 ++++++++++----------
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c       |  4 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        | 14 ++---
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c        | 14 +++--
 drivers/net/wireless/rtlwifi/rtl8723ae/dm.c        |  5 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c        | 60 ++++++++++------------
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c       |  4 +-
 drivers/net/wireless/rtlwifi/rtl8723be/dm.c        |  2 +-
 drivers/net/wireless/rtlwifi/rtl8723be/hw.c        | 57 ++++++++++----------
 drivers/net/wireless/rtlwifi/rtl8723be/trx.c       |  4 +-
 .../net/wireless/rtlwifi/rtl8723com/fw_common.c    |  4 +-
 23 files changed, 132 insertions(+), 151 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty


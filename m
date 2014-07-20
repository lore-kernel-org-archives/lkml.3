Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaGTORQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:17:16 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:44522 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbaGTORO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:17:14 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswMALLOy1NXQ0aj/2dsb2JhbABZgw6vRgYBAQEBAQUBBWmdSIEFF3aEYCOBGoh9AbAxkQeFe4lQhE0FmyWUL4NGOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        e1000-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com
Subject: [PATCH 00/30] drivers/net: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:16:08 +0200
Message-Id: <1405865801-18806-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second patchset after "remove unnecessary break after goto" addressing break redundancy on drivers/net branch
(suggested by Joe Perches)

Fabian Frederick (30):
  dlci: remove unnecessary break after return
  eth_v10: remove unnecessary break after return
  brcm80211: remove unnecessary break after return
  mwl8k: remove unnecessary break after return
  rtlwifi: remove unnecessary break after return
  rtlwifi: rtl8192ce: remove unnecessary break after return
  rtlwifi: rtl8192se: remove unnecessary break after return
  rtlwifi: rtl8723ae: remove unnecessary break after return
  rtlwifi: rtl8723be: remove unnecessary break after return
  rtlwifi: rtl8188ee: remove unnecessary break after return
  prism54: remove unnecessary break after return
  cw1200: remove unnecessary break after return
  airo: remove unnecessary break after return
  ath6kl: remove unnecessary break after return
  carl9170: remove unnecessary break after return
  i40e: remove unnecessary break after return
  e1000: remove unnecessary break after return
  ixgbe: remove unnecessary break after return
  e1000e: remove unnecessary break after return
  igb: remove unnecessary break after return
  8390: remove unnecessary break after return
  net: tulip: remove unnecessary break after return
  bna: remove unnecessary break after return
  sis900: remove unnecessary break after return
  niu: remove unnecessary break after return
  ucc_geth: remove unnecessary break after return
  atl1e: remove unnecessary break after return
  atlx: remove unnecessary break after return
  atl1c: remove unnecessary break after return
  ps3_gelic: remove unnecessary break after return

 drivers/net/cris/eth_v10.c                          | 1 -
 drivers/net/ethernet/8390/mac8390.c                 | 8 --------
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.c       | 2 --
 drivers/net/ethernet/atheros/atl1e/atl1e_hw.c       | 1 -
 drivers/net/ethernet/atheros/atlx/atl1.c            | 1 -
 drivers/net/ethernet/atheros/atlx/atl2.c            | 3 ---
 drivers/net/ethernet/brocade/bna/cna_fwimg.c        | 4 ----
 drivers/net/ethernet/dec/tulip/de4x5.c              | 1 -
 drivers/net/ethernet/freescale/ucc_geth.c           | 2 --
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c    | 3 ---
 drivers/net/ethernet/intel/e1000/e1000_hw.c         | 2 --
 drivers/net/ethernet/intel/e1000e/82571.c           | 4 ----
 drivers/net/ethernet/intel/e1000e/ethtool.c         | 2 --
 drivers/net/ethernet/intel/e1000e/ich8lan.c         | 1 -
 drivers/net/ethernet/intel/e1000e/mac.c             | 1 -
 drivers/net/ethernet/intel/i40e/i40e_common.c       | 1 -
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c  | 1 -
 drivers/net/ethernet/intel/igb/e1000_82575.c        | 1 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c     | 1 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c    | 2 --
 drivers/net/ethernet/sis/sis900.c                   | 1 -
 drivers/net/ethernet/sun/niu.c                      | 1 -
 drivers/net/ethernet/toshiba/ps3_gelic_wireless.c   | 7 -------
 drivers/net/wan/dlci.c                              | 1 -
 drivers/net/wireless/airo.c                         | 1 -
 drivers/net/wireless/ath/ath6kl/init.c              | 1 -
 drivers/net/wireless/ath/carl9170/phy.c             | 1 -
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c       | 1 -
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c | 1 -
 drivers/net/wireless/cw1200/fwio.c                  | 1 -
 drivers/net/wireless/mwl8k.c                        | 5 -----
 drivers/net/wireless/prism54/oid_mgt.c              | 1 -
 drivers/net/wireless/rtlwifi/core.c                 | 1 -
 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.c  | 1 -
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c         | 1 -
 drivers/net/wireless/rtlwifi/rtl8192se/fw.c         | 3 ---
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c         | 1 -
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c         | 1 -
 drivers/net/wireless/rtlwifi/rtl8723be/pwrseqcmd.c  | 1 -
 39 files changed, 73 deletions(-)

-- 
1.9.1


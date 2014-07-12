Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaGLSKp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 14:10:45 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:9202 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbaGLSKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 14:10:42 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiwMAJB5wVNXQ56W/2dsb2JhbABZgw6tLQUBAQEBAQEFAW6bf4ERF3WEYCOBGoh9AbUIkiSFe4lQHYQtBZsOlB2DRjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH V2 0/9] drivers/net: remove unnecessary break after goto
Date: Sat, 12 Jul 2014 20:09:39 +0200
Message-Id: <1405188597-2815-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small patchset addressing break redundancy on drivers/net branch
(suggested by Joe Perches). 

V2: cc to maintainers of each section.


Fabian Frederick (9):
  igb: remove unnecessary break after goto
  ixgbe: remove unnecessary break after goto
  i40e: remove unnecessary break after goto
  i40evf: remove unnecessary break after goto
  ps3_gelic: remove unnecessary break after goto
  orinoco_usb: remove unnecessary break after goto
  wcn36xx: remove unnecessary break after goto
  rtlwifi: remove unnecessary break after goto
  slip: remove unnecessary break after goto

 drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c    | 2 --
 drivers/net/ethernet/intel/i40evf/i40evf_main.c   | 2 --
 drivers/net/ethernet/intel/igb/e1000_82575.c      | 1 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c    | 1 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c    | 4 ----
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c   | 2 --
 drivers/net/ethernet/toshiba/ps3_gelic_wireless.c | 3 ---
 drivers/net/slip/slhc.c                           | 1 -
 drivers/net/wireless/ath/wcn36xx/main.c           | 1 -
 drivers/net/wireless/orinoco/orinoco_usb.c        | 1 -
 drivers/net/wireless/rtlwifi/rtl8192se/fw.c       | 1 -
 11 files changed, 19 deletions(-)

-- 
1.9.1


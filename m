Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaHTLyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:54:40 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59001 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Fujinaka, Todd" <todd.fujinaka@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 083/104] igb: Add ethtool offline tests for i354
Date: Wed, 20 Aug 2014 13:43:46 +0200
Message-Id: <0f65001beb4ddac42def967c2ae6c6387cec9848.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Fujinaka, Todd" <todd.fujinaka@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a4e979a27db3eb77e286dbe484e96c0c9c986e83 upstream.

Add the ethtool offline tests for i354 devices.

Signed-off-by: Todd Fujinaka <todd.fujinaka@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 151e00cad113..7bcf1ce59b41 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -1659,7 +1659,8 @@ static int igb_setup_loopback_test(struct igb_adapter *adapter)
 		if ((hw->device_id == E1000_DEV_ID_DH89XXCC_SGMII) ||
 		(hw->device_id == E1000_DEV_ID_DH89XXCC_SERDES) ||
 		(hw->device_id == E1000_DEV_ID_DH89XXCC_BACKPLANE) ||
-		(hw->device_id == E1000_DEV_ID_DH89XXCC_SFP)) {
+		(hw->device_id == E1000_DEV_ID_DH89XXCC_SFP) ||
+		(hw->device_id == E1000_DEV_ID_I354_SGMII)) {
 
 			/* Enable DH89xxCC MPHY for near end loopback */
 			reg = rd32(E1000_MPHY_ADDR_CTL);
@@ -1725,7 +1726,8 @@ static void igb_loopback_cleanup(struct igb_adapter *adapter)
 	if ((hw->device_id == E1000_DEV_ID_DH89XXCC_SGMII) ||
 	(hw->device_id == E1000_DEV_ID_DH89XXCC_SERDES) ||
 	(hw->device_id == E1000_DEV_ID_DH89XXCC_BACKPLANE) ||
-	(hw->device_id == E1000_DEV_ID_DH89XXCC_SFP)) {
+	(hw->device_id == E1000_DEV_ID_DH89XXCC_SFP) ||
+	(hw->device_id == E1000_DEV_ID_I354_SGMII)) {
 		u32 reg;
 
 		/* Disable near end loopback on DH89xxCC */
-- 
2.0.4


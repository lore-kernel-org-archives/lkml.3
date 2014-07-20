Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbaGTO1e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:27:34 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:37955 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753199AbaGTO0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:26:51 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIKAEfRy1NXQ0aj/2dsb2JhbABZgw6BKa4jAQEBAQEFAW6dSAGBBBd2hAQBBVYjEFE5HhmIRgGwNJBxF4V7iVAHFoQwBZsllC+DRjsv
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Linux NICS <linux.nics@intel.com>, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org
Subject: [PATCH 18/30] ixgbe: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:25:19 +0200
Message-Id: <1405866332-24652-9-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405866332-24652-1-git-send-email-fabf@skynet.be>
References: <1405866332-24652-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c  | 1 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
index 5172b6b..e70bf03 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
@@ -460,7 +460,6 @@ static int ixgbe_dcbnl_getnumtcs(struct net_device *netdev, int tcid, u8 *num)
 			break;
 		default:
 			return -EINVAL;
-			break;
 		}
 	} else {
 		return -EINVAL;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index a452730..94a1c07 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1408,7 +1408,6 @@ static int ixgbe_reg_test(struct ixgbe_adapter *adapter, u64 *data)
 	default:
 		*data = 1;
 		return 1;
-		break;
 	}
 
 	/*
@@ -2866,7 +2865,6 @@ static int ixgbe_get_ts_info(struct net_device *dev,
 		break;
 	default:
 		return ethtool_op_get_ts_info(dev, info);
-		break;
 	}
 	return 0;
 }
-- 
1.9.1


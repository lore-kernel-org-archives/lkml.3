Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaGTO2c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:28:32 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:12023 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960AbaGTO23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:28:29 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlgNAA/Ry1NXQ0aj/2dsb2JhbABZgw6BKa4dBgEBAQEBBQEFaZ1IgQUXdoRgI4EaN4hGAbAzkQiFe4hsZB2EMAWbJZQvg0Y7L4ED
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
Subject: [PATCH 20/30] igb: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:27:45 +0200
Message-Id: <1405866475-24754-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/ethernet/intel/igb/e1000_82575.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_82575.c b/drivers/net/ethernet/intel/igb/e1000_82575.c
index ee74f95..807496e 100644
--- a/drivers/net/ethernet/intel/igb/e1000_82575.c
+++ b/drivers/net/ethernet/intel/igb/e1000_82575.c
@@ -579,7 +579,6 @@ static s32 igb_get_invariants_82575(struct e1000_hw *hw)
 		break;
 	default:
 		return -E1000_ERR_MAC_INIT;
-		break;
 	}
 
 	/* Set media type */
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbaGHTF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:05:56 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:45828 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932328AbaGHTFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:05:53 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgNAORAvFNXQDwH/2dsb2JhbABZgw6tJQEBAQEBAQUBbgGZWQGBFxd1hAQBBXkQUTkeGYhGAcgmF4V6iGRkBxaELQWadpQMg0U7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/9] igb: remove unnecessary break after goto
Date: Tue,  8 Jul 2014 21:05:21 +0200
Message-Id: <1404846329-19235-2-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1404846329-19235-1-git-send-email-fabf@skynet.be>
References: <1404846329-19235-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/ethernet/intel/igb/e1000_82575.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_82575.c b/drivers/net/ethernet/intel/igb/e1000_82575.c
index a2db388..168a5ee 100644
--- a/drivers/net/ethernet/intel/igb/e1000_82575.c
+++ b/drivers/net/ethernet/intel/igb/e1000_82575.c
@@ -837,7 +837,6 @@ static s32 igb_get_phy_id_82575(struct e1000_hw *hw)
 		default:
 			ret_val = -E1000_ERR_PHY;
 			goto out;
-			break;
 		}
 		ret_val = igb_get_phy_id(hw);
 		goto out;
-- 
1.8.4.5


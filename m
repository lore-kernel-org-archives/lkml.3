Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbaGTOaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:30:24 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:62322 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753612AbaGTO2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:28:50 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIKAA/Ry1NXQ0aj/2dsb2JhbABZgw6BKa4jAQEBAQEFAW6dSAGBBBd2hAQBBScvIxBROR4ZiEYBsDOQcReFe4hsZAcWhDAFmyWUL4NGOy+BAw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        netdev@vger.kernel.org
Subject: [PATCH 25/30] niu: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:27:50 +0200
Message-Id: <1405866475-24754-6-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405866475-24754-1-git-send-email-fabf@skynet.be>
References: <1405866475-24754-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/ethernet/sun/niu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 79606f47a..db8ffde 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -2584,7 +2584,6 @@ static int niu_determine_phy_disposition(struct niu *np)
 				break;
 			default:
 				return -EINVAL;
-				break;
 			}
 			phy_addr_off = niu_atca_port_num[np->port];
 			break;
-- 
1.9.1


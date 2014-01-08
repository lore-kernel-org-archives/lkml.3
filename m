Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbaAHC66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 21:58:58 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:42841 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbaAHCx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 21:53:26 -0500
Message-ID: <52CCBD99.4020106@huawei.com>
Date: Wed, 8 Jan 2014 10:53:13 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Li Yang <leoli@freescale.com>, Netdev <netdev@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3.6 01/19] net: freescale: remove unused compare_addr()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function did not be used any more, so remove it.

Cc: Li Yang <leoli@freescale.com>
Cc: netdev@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 5548b6d..72291a8 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -435,11 +435,6 @@ static void hw_add_addr_in_hash(struct ucc_geth_private *ugeth,
 		     QE_CR_PROTOCOL_ETHERNET, 0);
 }
 
-static inline int compare_addr(u8 **addr1, u8 **addr2)
-{
-	return memcmp(addr1, addr2, ETH_ALEN);
-}
-
 #ifdef DEBUG
 static void get_statistics(struct ucc_geth_private *ugeth,
 			   struct ucc_geth_tx_firmware_statistics *
-- 
1.8.0



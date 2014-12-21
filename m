Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbaLURiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 12:38:54 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:64201 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaLURiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 12:38:52 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: "David S. Miller" <davem@davemloft.net>,
        dingtianhong <dingtianhong@huawei.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Benoit Taine <benoit.taine@lip6.fr>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Joe Perches <joe@perches.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: micrel: ksz884x.c:  Remove unused function
Date: Sun, 21 Dec 2014 18:41:38 +0100
Message-Id: <1419183698-10495-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function port_cfg_dis_learn() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/ethernet/micrel/ksz884x.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index f1ebed6c..2fa6ae0 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -2303,12 +2303,6 @@ static inline int port_chk_force_flow_ctrl(struct ksz_hw *hw, int p)
 
 /* Spanning Tree */
 
-static inline void port_cfg_dis_learn(struct ksz_hw *hw, int p, int set)
-{
-	port_cfg(hw, p,
-		KS8842_PORT_CTRL_2_OFFSET, PORT_LEARN_DISABLE, set);
-}
-
 static inline void port_cfg_rx(struct ksz_hw *hw, int p, int set)
 {
 	port_cfg(hw, p,
-- 
1.7.10.4


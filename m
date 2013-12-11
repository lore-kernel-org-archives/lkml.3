Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab3LKXBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 18:01:18 -0500
Received: from smtp2.macqel.be ([109.135.2.61]:57532 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab3LKXBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 18:01:15 -0500
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Dec 2013 18:01:15 EST
From: phdm@macqel.be
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        frank.li@freescale.net
Cc: Philippe De Muyter <phdm@macqel.be>
Subject: [PATCH] net:fec: remove duplicate lines in comment about errata ERR006358
Date: Wed, 11 Dec 2013 23:50:52 +0100
Message-Id: <1386802252-5817-1-git-send-email-phdm@macqel.be>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe De Muyter <phdm@macqel.be>

commit 031916568a1aa2ef1809f86d26f0bcfa215ff5c0 worked around
errata ERR006358, but comment contains duplicated lines, impairing
the readability.  Remove them.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
---
 drivers/net/ethernet/freescale/fec_main.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 4cbebf3..36bcc48 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -98,10 +98,6 @@ static void set_multicast_list(struct net_device *ndev);
  * detected as not set during a prior frame transmission, then the
  * ENET_TDAR[TDAR] bit is cleared at a later time, even if additional TxBDs
  * were added to the ring and the ENET_TDAR[TDAR] bit is set. This results in
- * If the ready bit in the transmit buffer descriptor (TxBD[R]) is previously
- * detected as not set during a prior frame transmission, then the
- * ENET_TDAR[TDAR] bit is cleared at a later time, even if additional TxBDs
- * were added to the ring and the ENET_TDAR[TDAR] bit is set. This results in
  * frames not being transmitted until there is a 0-to-1 transition on
  * ENET_TDAR[TDAR].
  */
-- 
1.7.5.3


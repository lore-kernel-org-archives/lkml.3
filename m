Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab3CJIKn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 04:10:43 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:34419 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3CJIKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 04:10:36 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Brett Rudley <brudley@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>
Subject: [PATCH -mmotm] brcm80211: fix the misaligned indentation
Date: Sun, 10 Mar 2013 17:10:14 +0900
Message-Id: <1362903014-25192-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the misaligned indentation introduced by
drivers-net-rename-random32-to-prandom_u32.patch in the -mm tree.

This also remove unneeded parentheses in order not to cause line over
80 characters.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>
Cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Cc: Hante Meuleman <meuleman@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index bca31a8..5da1645 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -1118,7 +1118,7 @@ static void brcmf_p2p_afx_handler(struct work_struct *work)
 	if (afx_hdl->is_listen && afx_hdl->my_listen_chan)
 		/* 100ms ~ 300ms */
 		err = brcmf_p2p_discover_listen(p2p, afx_hdl->my_listen_chan,
-					100 * (1 + (prandom_u32() % 3)));
+						100 * (1 + prandom_u32() % 3));
 	else
 		err = brcmf_p2p_act_frm_search(p2p, afx_hdl->peer_listen_chan);
 
-- 
1.8.1.4


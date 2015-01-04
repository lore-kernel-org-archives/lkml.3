Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbbADJGc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 04:06:32 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:44730 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbADJGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 04:06:30 -0500
From: Ning Zhou <zhou.ning.gd@gmail.com>
To: gregkh@linuxfoundation.org
Cc: monamagarwal123@gmail.com, sjw0410@gmail.com,
        peter.p.waskiewicz.jr@intel.com, teg@jklm.no, dilekuzulmez@gmail.com,
        gulsah.1004@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        Ning Zhou <zhou.ning.gd@gmail.com>
Subject: [PATCH] staging: gdm724x: fix line limit coding style issue in gdm_lte.c
Date: Sun,  4 Jan 2015 10:06:17 +0100
Message-Id: <1420362377-16630-1-git-send-email-zhou.ning.gd@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to fix "WARNING: line over 80 characters" found by
checkpatch.pl in gdm_lte.c.

Signed-off-by: Ning Zhou <zhou.ning.gd@gmail.com>
---
 drivers/staging/gdm724x/gdm_lte.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/gdm724x/gdm_lte.c b/drivers/staging/gdm724x/gdm_lte.c
index 73eede1..7c4a77b 100644
--- a/drivers/staging/gdm724x/gdm_lte.c
+++ b/drivers/staging/gdm724x/gdm_lte.c
@@ -281,7 +281,8 @@ static int gdm_lte_emulate_ndp(struct sk_buff *skb_in, u32 nic_type)
 		icmp6_out.icmp6_type = NDISC_NEIGHBOUR_ADVERTISEMENT;
 		icmp6_out.icmp6_code = 0;
 		icmp6_out.icmp6_cksum = 0;
-		icmp6_out.icmp6_dataun.un_data32[0] = htonl(0x60000000); /* R=0, S=1, O=1 */
+		/* R=0, S=1, O=1 */
+		icmp6_out.icmp6_dataun.un_data32[0] = htonl(0x60000000);
 
 		ns = (struct neighbour_solicitation *)
 			(skb_in->data + mac_header_len +
-- 
1.9.1


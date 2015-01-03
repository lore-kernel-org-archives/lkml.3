Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbbACQFm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 11:05:42 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:53219 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbbACQFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 11:05:41 -0500
From: Ning Zhou <zhou.ning.gd@gmail.com>
To: gregkh@linuxfoundation.org
Cc: teg@jklm.no, davem@davemloft.net, dh.herrmann@gmail.com,
        gulsah.1004@gmail.com, dilekuzulmez@gmail.com, sjw0410@gmail.com,
        monamagarwal123@gmail.com, daniel.dy.ngu@gmail.com,
        josh@joshtriplett.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Ning Zhou <zhou.ning.gd@gmail.com>
Subject: [PATCH] staging: gdm724x: fix coding style issues
Date: Sat,  3 Jan 2015 17:03:55 +0100
Message-Id: <1420301035-29052-1-git-send-email-zhou.ning.gd@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ning Zhou <zhou.ning.gd@gmail.com>
---
 drivers/staging/gdm724x/gdm_lte.c | 3 ++-
 drivers/staging/gdm724x/gdm_mux.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

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
diff --git a/drivers/staging/gdm724x/gdm_mux.c b/drivers/staging/gdm724x/gdm_mux.c
index b5b063a..d1ab996 100644
--- a/drivers/staging/gdm724x/gdm_mux.c
+++ b/drivers/staging/gdm724x/gdm_mux.c
@@ -220,7 +220,7 @@ static int up_to_host(struct mux_rx *r)
 static void do_rx(struct work_struct *work)
 {
 	struct mux_dev *mux_dev =
-		container_of(work, struct mux_dev , work_rx.work);
+		container_of(work, struct mux_dev, work_rx.work);
 	struct mux_rx *r;
 	struct rx_cxt *rx = (struct rx_cxt *)&mux_dev->rx;
 	unsigned long flags;
-- 
1.9.1


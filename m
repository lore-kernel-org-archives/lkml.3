Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaKQVAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:00:30 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:51288 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751297AbaKQVA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:00:26 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4SAK5galRXQyyZ/2dsb2JhbABbgw6BLrhwBQF1mg8EAoEbFwEBAQEBfYRfI4EaN4hFAcJhkEmGPooAZB2ENQWeTJZ6gUcBgjU8MIEGgUUBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>, dccp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] dccp: spelling s/reseting/resetting
Date: Mon, 17 Nov 2014 22:00:22 +0100
Message-Id: <1416258022-7320-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/dccp/input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dccp/input.c b/net/dccp/input.c
index 3c8ec7d..3bd14e8 100644
--- a/net/dccp/input.c
+++ b/net/dccp/input.c
@@ -537,7 +537,7 @@ static int dccp_rcv_respond_partopen_state_process(struct sock *sk,
 	case DCCP_PKT_DATAACK:
 	case DCCP_PKT_ACK:
 		/*
-		 * FIXME: we should be reseting the PARTOPEN (DELACK) timer
+		 * FIXME: we should be resetting the PARTOPEN (DELACK) timer
 		 * here but only if we haven't used the DELACK timer for
 		 * something else, like sending a delayed ack for a TIMESTAMP
 		 * echo, etc, for now were not clearing it, sending an extra
-- 
1.9.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259AbaGNQfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:35:54 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:28504 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756515AbaGNQfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:35:36 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgNAIUGxFNXQxRI/2dsb2JhbABZgw6tSQEBAQEBAQUBbpt/AYEVF3WEBAEFViMQUTkeGYhGAcg2F4V7iVAHFoQtBZsOlB6DRjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-wireless@vger.kernel.org,
        linux-nfc@ml01.01.org, netdev@vger.kernel.org
Subject: [PATCH 12/16] NFC: remove unnecessary break after goto
Date: Mon, 14 Jul 2014 18:36:35 +0200
Message-Id: <1405355799-7691-3-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1405355799-7691-1-git-send-email-fabf@skynet.be>
References: <1405355799-7691-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/nfc/digital_dep.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/nfc/digital_dep.c b/net/nfc/digital_dep.c
index 171cb99..37deb17 100644
--- a/net/nfc/digital_dep.c
+++ b/net/nfc/digital_dep.c
@@ -457,12 +457,10 @@ static void digital_tg_recv_dep_req(struct nfc_digital_dev *ddev, void *arg,
 		pr_err("Received a ACK/NACK PDU\n");
 		rc = -EINVAL;
 		goto exit;
-		break;
 	case DIGITAL_NFC_DEP_PFB_SUPERVISOR_PDU:
 		pr_err("Received a SUPERVISOR PDU\n");
 		rc = -EINVAL;
 		goto exit;
-		break;
 	}
 
 	skb_pull(resp, size);
-- 
1.8.4.5


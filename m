Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaKDTKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:10:13 -0500
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:27915 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751563AbaKDTKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:10:11 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4SACojWVRbsl9p/2dsb2JhbABbgw6BLLp9BgEBAQEBBQF0miIEAoEkFwEBAQEBfYRfI4EaN4hFAb5ejzaGN4l1ZB2ENQWeB5ZPgUcBgjE8L4EGgUUBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] cipso: kerneldoc warning fix
Date: Tue,  4 Nov 2014 20:10:01 +0100
Message-Id: <1415128201-8246-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ipv4/cipso_ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 4715f25..e24df5a 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -539,7 +539,7 @@ doi_add_return:
 
 /**
  * cipso_v4_doi_free - Frees a DOI definition
- * @entry: the entry's RCU field
+ * @doi_def: the DOI definition
  *
  * Description:
  * This function frees all of the memory associated with a DOI definition.
-- 
1.9.3


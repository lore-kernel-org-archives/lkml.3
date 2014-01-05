Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbaAEMfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 07:35:54 -0500
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22]:58661 "EHLO
	mx-rz-3.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164AbaAEMfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 07:35:13 -0500
X-RRZE-Submit-IP: 62.245.163.133
From: Andreas Frembs <andreas.frembs@studium.uni-erlangen.de>
To: andreas.frembs@studium.uni-erlangen.de
Cc: matthias.schoepe@studium.uni-erlangen.de, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, dhowells@redhat.com,
        viro@zeniv.linux.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linville@tuxdriver.com,
        andrea.merello@gmail.com, valentina.manea.m@gmail.com,
        lisa@xenapiadmin.com
Subject: [PATCH 1/3] Staging rtl8192e: Fixing checkpatch error in rtllib_crypt_tkip.c
Date: Sun,  5 Jan 2014 13:25:35 +0100
Message-Id: <1388924737-1412-2-git-send-email-andreas.frembs@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1388924737-1412-1-git-send-email-andreas.frembs@studium.uni-erlangen.de>
References: <1388924737-1412-1-git-send-email-andreas.frembs@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In rtllib_crypt_tkip.c we fixed the following checkpatch error:
	ERROR: space required after that ','

Signed-off-by: Andreas Frembs <andreas.frembs@studium.uni-erlangen.de>
Signed-off-by: Matthias Schoepe <matthias.schoepe@studium.uni-erlangen.de>
---
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtllib_crypt_tkip.c b/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
index 5cfd73b..120d174 100644
--- a/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
+++ b/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
@@ -427,7 +427,7 @@ static int rtllib_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 			if (net_ratelimit()) {
 				printk(KERN_DEBUG "TKIP: replay detected: STA="
 				       " %pM previous TSC %08x%04x received "
-				      "TSC %08x%04x\n",hdr->addr2,
+				      "TSC %08x%04x\n", hdr->addr2,
 				      tkey->rx_iv32, tkey->rx_iv16, iv32, iv16);
 			}
 			tkey->dot11RSNAStatsTKIPReplays++;
-- 
1.8.5.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaJARaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:30:15 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:18483 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751236AbaJARaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:30:13 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYSALE5LFRbsmCr/2dsb2JhbABggw6BLLY3BQFyAZpTBAKBDhcBe4RgI4EaN4hCAa8qj2+GFYktZB2ENQWdM4xJiSqDZTsvgQaBRAEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] cipso: add __init to cipso_v4_cache_init
Date: Wed,  1 Oct 2014 19:30:03 +0200
Message-Id: <1412184603-17294-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cipso_v4_cache_init is only called by __init cipso_v4_init

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ipv4/cipso_ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 05b708b..4715f25 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -246,7 +246,7 @@ static u32 cipso_v4_map_cache_hash(const unsigned char *key, u32 key_len)
  * success, negative values on error.
  *
  */
-static int cipso_v4_cache_init(void)
+static int __init cipso_v4_cache_init(void)
 {
 	u32 iter;
 
-- 
1.9.3


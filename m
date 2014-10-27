Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbaJ0SNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:13:05 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:51908 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753125AbaJ0SNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:13:02 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AroUAAiKTlRXQ3zJ/2dsb2JhbABcgw6BLI4Bq0ILBQF0mj0EAoEeFwF9hF8jgRo3iEUBvGuPCIY0iXBkHYQ1BZ1hli6BRwGCMTwvgQaBRQEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] ipv6: include linux/uaccess.h instead of asm/uaccess.h
Date: Mon, 27 Oct 2014 19:12:58 +0100
Message-Id: <1414433578-29321-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ipv6/exthdrs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index bfde361..601d896 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -47,7 +47,7 @@
 #include <net/xfrm.h>
 #endif
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 /*
  *	Parsing tlv encoded headers.
-- 
1.9.1


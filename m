Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbaJVTHC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:07:02 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:17142 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932247AbaJVTHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:07:00 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYSAGv/R1RR86AM/2dsb2JhbABcgw6BLLh3BQFzmjgEAoEPFwF9hF8jgRo3iEQBtyiPC4YliU5kHYQ1BZ1dliqBRwGCMjsvgQaBRQEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] net: llc: include linux/errno.h instead of asm/errno.h
Date: Wed, 22 Oct 2014 21:06:26 +0200
Message-Id: <1414004787-7936-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/llc/llc_if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/llc/llc_if.c b/net/llc/llc_if.c
index 25c31c0..6daf391 100644
--- a/net/llc/llc_if.c
+++ b/net/llc/llc_if.c
@@ -15,7 +15,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
-#include <asm/errno.h>
+#include <linux/errno.h>
 #include <net/llc_if.h>
 #include <net/llc_sap.h>
 #include <net/llc_s_ev.h>
-- 
1.9.1


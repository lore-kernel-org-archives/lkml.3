Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaKQVI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:08:27 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:16353 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbaKQVI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:08:26 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4SAD1jalRXQyyZ/2dsb2JhbABbgw6BLrhwBQF1mg8EAoEWFwEBAQEBfYRfI4EaN4hFAcJTkEyGPooAZB2ENQWeTJZ6gUcBgjU8MIEGgUUBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] net/core: include linux/types.h instead of asm/types.h
Date: Mon, 17 Nov 2014 22:08:22 +0100
Message-Id: <1416258502-9001-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/core/link_watch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index bd0767e..49a9e3e 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -21,7 +21,7 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/bitops.h>
-#include <asm/types.h>
+#include <linux/types.h>
 
 
 enum lw_bits {
-- 
1.9.3


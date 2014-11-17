Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaKQVKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:10:30 -0500
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:13482 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751515AbaKQVK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:10:28 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4SAD1jalRXQyyZ/2dsb2JhbABbgw6BLrhwBQF1mg8EAoEWFwEBAQEBfYRfI4EaN4hFAcJTkEyGPooAZB2ENQWeTJZ6gUcBgjU8MIEGgUUBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] net/core: include linux/uaccess.h instead of asm/uaccess.h
Date: Mon, 17 Nov 2014 22:10:23 +0100
Message-Id: <1416258624-9577-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/core/gen_estimator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/gen_estimator.c b/net/core/gen_estimator.c
index 9dfb88a..d654d6f 100644
--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -13,7 +13,7 @@
  *              names to make it usable in general net subsystem.
  */
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/bitops.h>
 #include <linux/module.h>
 #include <linux/types.h>
-- 
1.9.3


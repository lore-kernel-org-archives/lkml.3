Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbaHGPHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:07:10 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:49104 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbaHGPHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:07:08 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-zigbee-devel@lists.sourceforge.net, linux-bluetooth@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] 6lowpan: Allow 6LoWPAN to be modular
Date: Thu,  7 Aug 2014 17:06:43 +0200
Message-Id: <1407424003-15073-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change config symbol 6LOWPAN from type bool to type tristate, so
6LoWPAN can be built modular, just like IPV6

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 net/6lowpan/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/6lowpan/Kconfig b/net/6lowpan/Kconfig
index 028a5c6d1f61..e4a02ef55102 100644
--- a/net/6lowpan/Kconfig
+++ b/net/6lowpan/Kconfig
@@ -1,5 +1,5 @@
 config 6LOWPAN
-	bool "6LoWPAN Support"
+	tristate "6LoWPAN Support"
 	depends on IPV6
 	---help---
 	  This enables IPv6 over Low power Wireless Personal Area Network -
-- 
1.9.1


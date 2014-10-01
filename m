Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaJAKH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 06:07:27 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:51996 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaJAKHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 06:07:22 -0400
From: Julien Catalano <julien.catalano@gmail.com>
To: alex.aring@gmail.com, trivial@kernel.org
Cc: linux-zigbee-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Julien Catalano <julien.catalano@gmail.com>
Subject: [PATCH] trivial: net/mac802154: Fix Kconfig typo
Date: Wed,  1 Oct 2014 12:06:58 +0200
Message-Id: <1412158018-8707-1-git-send-email-julien.catalano@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Julien Catalano <julien.catalano@gmail.com>
---
 net/mac802154/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac802154/Kconfig b/net/mac802154/Kconfig
index 1818a99..aa462b4 100644
--- a/net/mac802154/Kconfig
+++ b/net/mac802154/Kconfig
@@ -16,5 +16,5 @@ config MAC802154
 	  been tested yet!
 
 	  If you plan to use HardMAC IEEE 802.15.4 devices, you can
-	  say N here. Alternatievly you can say M to compile it as
+	  say N here. Alternatively you can say M to compile it as
 	  module.
-- 
1.9.1


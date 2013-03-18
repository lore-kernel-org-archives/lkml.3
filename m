Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab3CRNLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:11:08 -0400
Received: from msa104.auone-net.jp ([61.117.18.164]:59622 "EHLO
	msa104.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3CRNLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:11:06 -0400
X-Greylist: delayed 669 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Mar 2013 09:11:06 EDT
Date: Mon, 18 Mar 2013 21:59:52 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] net: Fix a comment typo
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <20130318125952.CC5E615C03A@msa104.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index dffbef7..69f696a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3326,7 +3326,7 @@ EXPORT_SYMBOL_GPL(netdev_rx_handler_register);
  *	netdev_rx_handler_unregister - unregister receive handler
  *	@dev: device to unregister a handler from
  *
- *	Unregister a receive hander from a device.
+ *	Unregister a receive handler from a device.
  *
  *	The caller must hold the rtnl_mutex.
  */
-- 
1.7.10.4


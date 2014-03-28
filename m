Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbaC1KME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:12:04 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:35109 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaC1KMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:12:03 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH trivial 2/3] isdn: Grammar /is uses/ is used/
Date: Fri, 28 Mar 2014 11:11:38 +0100
Message-Id: <1396001499-17638-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396001499-17638-1-git-send-email-geert@linux-m68k.org>
References: <1396001499-17638-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Karsten Keil <isdn@linux-pingi.de>
---
 drivers/isdn/i4l/isdn_net.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/i4l/isdn_net.c b/drivers/isdn/i4l/isdn_net.c
index d9aebbc510cc..7b2b40477185 100644
--- a/drivers/isdn/i4l/isdn_net.c
+++ b/drivers/isdn/i4l/isdn_net.c
@@ -58,7 +58,7 @@
  * About SOFTNET:
  * Most of the changes were pretty obvious and basically done by HE already.
  *
- * One problem of the isdn net device code is that is uses struct net_device
+ * One problem of the isdn net device code is that it uses struct net_device
  * for masters and slaves. However, only master interface are registered to
  * the network layer, and therefore, it only makes sense to call netif_*
  * functions on them.
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaG3Vdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:33:54 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:58999 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaG3Vdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:33:53 -0400
From: fernando.apesteguia@gmail.com
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fernando Apesteguia <fernando.apesteguia@gmail.com>
Subject: [PATCH] Staging: rtl8192u: Staticfy debug method.
Date: Wed, 30 Jul 2014 23:33:41 +0200
Message-Id: <1406756021-3578-1-git-send-email-fernando.apesteguia@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fernando Apesteguia <fernando.apesteguia@gmail.com>

Add static to debug method.

Signed-off-by: Fernando Apesteguia <fernando.apesteguia@gmail.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 7640386..c732a67 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -667,7 +667,7 @@ static void tx_timeout(struct net_device *dev)
 
 
 /* this is only for debug */
-void dump_eprom(struct net_device *dev)
+static void dump_eprom(struct net_device *dev)
 {
 	int i;
 	for (i = 0; i < 63; i++)
-- 
1.7.9.5


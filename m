Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934217AbaCSN4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:56:10 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46258 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933597AbaCSN4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:56:08 -0400
From: Daniel Baluta <dbaluta@ixiacom.com>
To: davem@davemloft.net
Cc: dbaluta@ixiacom.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: remove empty lines from tcp_syn_flood_action
Date: Wed, 19 Mar 2014 15:58:24 +0200
Message-Id: <1395237505-20550-1-git-send-email-dbaluta@ixiacom.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
---
 net/ipv4/tcp_ipv4.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index c4f1d9a..4555244 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -880,8 +880,6 @@ bool tcp_syn_flood_action(struct sock *sk,
 	bool want_cookie = false;
 	struct listen_sock *lopt;
 
-
-
 #ifdef CONFIG_SYN_COOKIES
 	if (sysctl_tcp_syncookies) {
 		msg = "Sending cookies";
-- 
1.7.10.4


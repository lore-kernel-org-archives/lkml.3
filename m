Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199AbaK1GW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 01:22:26 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:56592 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaK1GWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 01:22:25 -0500
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Steven Noonan <steven@uplinklabs.net>
Subject: [PATCH] nf_log_ipv6: correct typo in module description
Date: Thu, 27 Nov 2014 22:22:19 -0800
Message-Id: <1417155739-5263-1-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It incorrectly identifies itself as "IPv4" packet logging.

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 net/ipv6/netfilter/nf_log_ipv6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/nf_log_ipv6.c b/net/ipv6/netfilter/nf_log_ipv6.c
index 7b17a0b..41b9ade 100644
--- a/net/ipv6/netfilter/nf_log_ipv6.c
+++ b/net/ipv6/netfilter/nf_log_ipv6.c
@@ -412,6 +412,6 @@ module_init(nf_log_ipv6_init);
 module_exit(nf_log_ipv6_exit);
 
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
-MODULE_DESCRIPTION("Netfilter IPv4 packet logging");
+MODULE_DESCRIPTION("Netfilter IPv6 packet logging");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NF_LOGGER(AF_INET6, 0);
-- 
2.1.3


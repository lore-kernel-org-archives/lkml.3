Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab3JWKg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:36:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45331 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753172Ab3JWKgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:36:24 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
        davem@davemloft.net
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] netfilter: ipset: remove duplicate define
Date: Wed, 23 Oct 2013 12:36:14 +0200
Message-Id: <1382524574-3214-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a duplicate define from
net/netfilter/ipset/ip_set_hash_gen.h

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 707bc52..b37a65f 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -243,7 +243,6 @@ hbucket_elem_add(struct hbucket *n, u8 ahash_max, size_t dsize)
 #define mtype_uadt		TOKEN(MTYPE, _uadt)
 #define mtype			MTYPE
 
-#define mtype_elem		TOKEN(MTYPE, _elem)
 #define mtype_add		TOKEN(MTYPE, _add)
 #define mtype_del		TOKEN(MTYPE, _del)
 #define mtype_test_cidrs	TOKEN(MTYPE, _test_cidrs)
-- 
1.8.1.2


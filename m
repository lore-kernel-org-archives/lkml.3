Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab3GKTP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 15:15:58 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:54885 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab3GKTP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 15:15:56 -0400
From: Dragos Foianu <dragos.foianu@gmail.com>
To: wensong@linux-vs.org
Cc: horms@verge.net.au, ja@ssi.bg, pablo@netfilter.org, kaber@trash.net,
        kadlec@blackhole.kfki.hu, davem@davemloft.net, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, Dragos Foianu <dragos.foianu@gmail.com>
Subject: [PATCH] ipvs: fixed style errors in ip_vs_dh
Date: Thu, 11 Jul 2013 22:15:44 +0300
Message-Id: <1373570144-4785-1-git-send-email-dragos.foianu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

found with the help of checkpatch.pl

Signed-off-by: Dragos Foianu <dragos.foianu@gmail.com>
---
 net/netfilter/ipvs/ip_vs_dh.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_dh.c b/net/netfilter/ipvs/ip_vs_dh.c
index c3b8454..8ab2fc8 100644
--- a/net/netfilter/ipvs/ip_vs_dh.c
+++ b/net/netfilter/ipvs/ip_vs_dh.c
@@ -110,7 +110,7 @@ ip_vs_dh_reassign(struct ip_vs_dh_state *s, struct ip_vs_service *svc)
 	b = &s->buckets[0];
 	p = &svc->destinations;
 	empty = list_empty(p);
-	for (i=0; i<IP_VS_DH_TAB_SIZE; i++) {
+	for (i = 0; i < IP_VS_DH_TAB_SIZE; i++) {
 		dest = rcu_dereference_protected(b->dest, 1);
 		if (dest)
 			ip_vs_dest_put(dest);
@@ -142,7 +142,7 @@ static void ip_vs_dh_flush(struct ip_vs_dh_state *s)
 	struct ip_vs_dest *dest;
 
 	b = &s->buckets[0];
-	for (i=0; i<IP_VS_DH_TAB_SIZE; i++) {
+	for (i = 0; i < IP_VS_DH_TAB_SIZE; i++) {
 		dest = rcu_dereference_protected(b->dest, 1);
 		if (dest) {
 			ip_vs_dest_put(dest);
@@ -244,8 +244,7 @@ ip_vs_dh_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 /*
  *      IPVS DH Scheduler structure
  */
-static struct ip_vs_scheduler ip_vs_dh_scheduler =
-{
+static struct ip_vs_scheduler ip_vs_dh_scheduler = {
 	.name =			"dh",
 	.refcnt =		ATOMIC_INIT(0),
 	.module =		THIS_MODULE,
-- 
1.7.10.4


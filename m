Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbaFXSkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:40:06 -0400
Received: from smtprelay0150.hostedemail.com ([216.40.44.150]:42340 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755174AbaFXSkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:40:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3867:3868:3872:4321:5007:7652:9592:10004:10400:10848:11026:11658:11914:12517:12519:12555:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: brass71_1d6c004cee40a
X-Filterd-Recvd-Size: 1429
Message-ID: <1403635200.29061.26.camel@joe-AO725>
Subject: [PATCH] kernel.h: Remove deprecated pack_hex_byte
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 24 Jun 2014 11:40:00 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been nearly 3 years now since commit 55036ba76b2d
("lib: rename pack_hex_byte() to hex_byte_pack()") so it's
time to remove this deprecated and unused static inline.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 44649e0..2416c82 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -493,11 +493,6 @@ static inline char *hex_byte_pack_upper(char *buf, u8 byte)
 	return buf;
 }
 
-static inline char * __deprecated pack_hex_byte(char *buf, u8 byte)
-{
-	return hex_byte_pack(buf, byte);
-}
-
 extern int hex_to_bin(char ch);
 extern int __must_check hex2bin(u8 *dst, const char *src, size_t count);
 



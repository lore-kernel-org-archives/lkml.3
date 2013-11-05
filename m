Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab3KEU6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 15:58:17 -0500
Received: from smtprelay0080.hostedemail.com ([216.40.44.80]:35251 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754726Ab3KEU6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 15:58:16 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1515:1516:1518:1534:1539:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3872:3876:4321:5007:7652:10004:10400:10848:11026:11473:11658:11914:12043:12438:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hill64_dbaf12c2141d
X-Filterd-Recvd-Size: 1402
Message-ID: <1383685095.4387.45.camel@joe-AO722>
Subject: [trivial PATCH] module.h: Remove unnecessary semicolon
From: Joe Perches <joe@perches.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 05 Nov 2013 12:58:15 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This semicolon isn't necessary, remove it.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/module.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 05f2447..d1ad477 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -454,7 +454,7 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 
 extern void __module_put_and_exit(struct module *mod, long code)
 	__attribute__((noreturn));
-#define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code);
+#define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code)
 
 #ifdef CONFIG_MODULE_UNLOAD
 unsigned long module_refcount(struct module *mod);



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbaFIRvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 13:51:38 -0400
Received: from smtprelay0233.hostedemail.com ([216.40.44.233]:45647 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751918AbaFIRvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 13:51:36 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3865:4321:5007:7652:9592:10004:10400:10848:11026:11658:11914:12296:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fly54_2ad5e5f213353
X-Filterd-Recvd-Size: 1233
Message-ID: <1402336292.3142.8.camel@joe-AO725>
Subject: [PATCH -next] sysctl: Remove now unused typedef ctl_table
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 09 Jun 2014 10:51:32 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the uses have been removed so remove the typedef.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/sysctl.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 14a8ff2..b7361f8 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -34,8 +34,6 @@ struct ctl_table_root;
 struct ctl_table_header;
 struct ctl_dir;
 
-typedef struct ctl_table ctl_table;
-
 typedef int proc_handler (struct ctl_table *ctl, int write,
 			  void __user *buffer, size_t *lenp, loff_t *ppos);
 



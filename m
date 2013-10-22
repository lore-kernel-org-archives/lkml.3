Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab3JVP53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:57:29 -0400
Received: from smtprelay0227.hostedemail.com ([216.40.44.227]:35505 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753018Ab3JVP52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:57:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2901:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:4362:5007:6120:7576:7652:7903:8828:9545:10004:10400:10450:10455:10848:10967:11232:11658:11914:12043:12262:12296:12438:12517:12519:12555:12679:12740:13019:13069:13071:13255:13311:13357:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: nose27_40e04b0ab0e4b
X-Filterd-Recvd-Size: 2395
Message-ID: <1382457444.2041.82.camel@joe-AO722>
Subject: Re: [RFC trivial] printk.c: /proc/vmcore instead of
 /proc/vmcoreinfo in comments?
From: Joe Perches <joe@perches.com>
To: Dirk Gouders <dirk@gouders.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 22 Oct 2013 08:57:24 -0700
In-Reply-To: <gik3h5tsbn.fsf@karga.hank.lab>
References: <gik3h5tsbn.fsf@karga.hank.lab>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-22 at 14:15 +0200, Dirk Gouders wrote:
> Hello Joe,
> 
> when having a look at printk.c, I noticed that two comments refer
> to /proc/vmcoreinfo and I wonder if that should not read /proc/vmcore.
> 
> While at it, a typo in one of those coments could also be fixed.

Hi Dirk.

Thanks and yes this is sensible.
Adding Andrew Morton to cc's and resending as plain-text

>From 2ef84ff3187633a3156c3a967c1dfc294292e492 Mon Sep 17 00:00:00 2001
From: Dirk Gouders <dirk@gouders.net>
Date: Tue, 22 Oct 2013 13:51:15 +0200
Subject: [PATCH] printk.c: comments should refer to /proc/vmcore instead of
 /proc/vmcoreinfo

In one of those comments a typo was fixed, too.

Signed-off-by: Dirk Gouders <dirk@gouders.net>
---
 kernel/printk/printk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index b4e8500..694d1f9 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -705,9 +705,9 @@ const struct file_operations kmsg_fops = {
 
 #ifdef CONFIG_KEXEC
 /*
- * This appends the listed symbols to /proc/vmcoreinfo
+ * This appends the listed symbols to /proc/vmcore
  *
- * /proc/vmcoreinfo is used by various utiilties, like crash and makedumpfile to
+ * /proc/vmcore is used by various utilities, like crash and makedumpfile to
  * obtain access to symbols that are otherwise very difficult to locate.  These
  * symbols are specifically used so that utilities can access and extract the
  * dmesg log from a vmcore file after a crash.
-- 
1.8.3.2




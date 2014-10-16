Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaJPJi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:38:59 -0400
Received: from smtprelay0174.hostedemail.com ([216.40.44.174]:43161 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750947AbaJPJi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:38:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:3868:3873:4321:5007:6261:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12679:12740:13018:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rod53_30a4ec8843e04
X-Filterd-Recvd-Size: 1416
Message-ID: <1413452333.6702.1.camel@perches.com>
Subject: Re: [PATCH] kernel:module Fix coding style errors and warnings.
From: Joe Perches <joe@perches.com>
To: Ionut Alexa <ionut.m.alexa@gmail.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Date: Thu, 16 Oct 2014 02:38:53 -0700
In-Reply-To: <1413452213-27450-1-git-send-email-ionut.m.alexa@gmail.com>
References: <1413452213-27450-1-git-send-email-ionut.m.alexa@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-16 at 12:36 +0300, Ionut Alexa wrote:
> Fixed codin style errors and warnings. Changes printk with
> print_debug/warn. Changed seq_printf to seq_puts.

If you are going to do style cleanups, please make
sure you check your patches with scripts/checkpatch.pl
before sending them.

WARNING: missing space after struct definition
#104: FILE: kernel/module.c:743:
+struct stopref{

WARNING: line over 80 characters
#190: FILE: kernel/module.c:1550:
+			error = sysfs_create_file(&mod->mkobj.kobj, &temp_attr->attr);

total: 0 errors, 2 warnings, 187 lines checked





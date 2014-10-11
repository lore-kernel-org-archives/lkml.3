Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaJKQkL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:40:11 -0400
Received: from smtprelay0057.hostedemail.com ([216.40.44.57]:49914 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750834AbaJKQkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:40:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2690:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3870:3871:4321:4605:5007:7652:8660:10004:10400:10848:11026:11658:11914:12043:12296:12438:12517:12519:12740:13069:13148:13161:13229:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shoe27_585ba5e961737
X-Filterd-Recvd-Size: 1913
Message-ID: <1413045605.16385.25.camel@joe-AO725>
Subject: Re: [PATCH] init: calibrate: fix style issues
From: Joe Perches <joe@perches.com>
To: Rasmus Wriedt Larsen <rasmuswriedtlarsen@gmail.com>
Cc: pdeschrijver@nvidia.com, rmk+kernel@arm.linux.org.uk, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Date: Sat, 11 Oct 2014 09:40:05 -0700
In-Reply-To: <1413045075-10416-1-git-send-email-rasmuswriedtlarsen@gmail.com>
References: <1413045075-10416-1-git-send-email-rasmuswriedtlarsen@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-11 at 18:31 +0200, Rasmus Wriedt Larsen wrote:
> * fix multiple quoted string split across lines style issues
> * change printk(KERN_NOTICE to pr_notice
> * insert spaces after , in function call
[]
> diff --git a/init/calibrate.c b/init/calibrate.c
[]
> @@ -160,9 +158,7 @@ static unsigned long calibrate_delay_direct(void)
>  
>  	}
>  
> -	printk(KERN_NOTICE "calibrate_delay_direct() failed to get a good "
> -	       "estimate for loops_per_jiffy.\nProbably due to long platform "
> -		"interrupts. Consider using \"lpj=\" boot option.\n");
> +	pr_notice("calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.\nProbably due to long platform interrupts. Consider using \"lpj=\" boot option.\n");

This would be better on 2 lines:
	pr_notice("calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.\n"
		  "Probably due to long platform interrupts. Consider using \"lpj=\" boot option.\n");

The grammar is poor though and this
could be better phrased.


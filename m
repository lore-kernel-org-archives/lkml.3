Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaHTPEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:04:12 -0400
Received: from smtprelay0045.hostedemail.com ([216.40.44.45]:49612 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750983AbaHTPEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:04:10 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3871:3873:4321:5007:7652:10004:10400:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12740:13019:13069:13071:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bells01_7082d4ee7d3a
X-Filterd-Recvd-Size: 1769
Message-ID: <1408547047.23250.27.camel@joe-AO725>
Subject: Re: [PATCH] staging: android: fix style issue
From: Joe Perches <joe@perches.com>
To: Purnendu Kapadia <pro8linux@gmail.com>
Cc: konkers@android.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Aug 2014 08:04:07 -0700
In-Reply-To: <1408544006-26673-1-git-send-email-pro8linux@gmail.com>
References: <1408544006-26673-1-git-send-email-pro8linux@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-20 at 15:13 +0100, Purnendu Kapadia wrote:
> checkpatch fix. add a line before the switch statement

Hello Purnendu.

This is a suboptimal patch description.

There is no generic style asking for a blank line
before a switch statement.

You are actually adding a blank line separating
declarations and code.

Specifying the change as a "checkpatch fix" is
also unnecessary.

A patch subject of

"[PATCH] staging: android: Add blank line after declaration"

with no patch description at all is probably good
enough.

> diff --git a/drivers/staging/android/sync.c b/drivers/staging/androchd/sync.c
[]
> @@ -705,6 +705,7 @@ static long sync_fence_ioctl(struct file *file, unsigned int cmd,
>  			     unsigned long arg)
>  {
>  	struct sync_fence *fence = file->private_data;
> +
>  	switch (cmd) {
>  	case SYNC_IOC_WAIT:
>  		return sync_fence_ioctl_wait(fence, arg);




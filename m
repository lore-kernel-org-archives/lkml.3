Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747AbbA0Urh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:47:37 -0500
Received: from smtprelay0237.hostedemail.com ([216.40.44.237]:38381 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751401AbbA0Urf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 15:47:35 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1567:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:2915:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6261:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13019:13069:13141:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ice16_5f0ecaab37b23
X-Filterd-Recvd-Size: 1592
Message-ID: <1422391651.13127.3.camel@perches.com>
Subject: Re: [PATCH 0/6] Fix fbtft/fb_pcd8544.c coding style errors
From: Joe Perches <joe@perches.com>
To: Heba Aamer <heba93aamer@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, notro@tronnes.org,
        thomas.petazzoni@free-electrons.com, linux-kernel@vger.kernel.org
Date: Tue, 27 Jan 2015 12:47:31 -0800
In-Reply-To: <cover.1422296762.git.heba93aamer@gmail.com>
References: <cover.1422296762.git.heba93aamer@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-27 at 22:30 +0200, Heba Aamer wrote:
> This patch set fixes most of the checkpatch.pl coding
> style errors found in drivers/staging/fbtft/fb_pcd8544.c
> 
> Heba Aamer (6):
>   staging: fbtft: fix space required after that ';'
>   staging: fbtft: fix spaces required around that '='
>   staging: fbtft: fix spaces required around that '<'

I suppose this is OK, but I think it's
better to do all the horizontal whitespace
changes in the same patch.

It's trivial and easy to verify all-at-once
instead of modifying the same line multiple
times.

It's also nice to say that git diff -w shows
no difference and that objdiff is empty.

>   staging: fbtft: fix trailing whitespace




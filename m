Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965175AbaFSVNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:13:45 -0400
Received: from smtprelay0174.hostedemail.com ([216.40.44.174]:45853 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934620AbaFSVNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:13:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:3868:3871:3874:4321:5007:6119:7652:7875:7903:8957:10004:10400:10848:11232:11658:11914:12043:12214:12517:12519:12555:12663:12740:13069:13071:13163:13200:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: salt12_3d27638aa3305
X-Filterd-Recvd-Size: 1464
Message-ID: <1403212419.2753.12.camel@joe-AO725>
Subject: Re: [PATCH] staging: iio: kernel style neatening
From: Joe Perches <joe@perches.com>
To: Federico Di Pierro <nierro92@gmail.com>
Cc: Jonathan Cameron <jic23@kernel.org>, gregkh@linuxfoundation.org,
        jg1.han@samsung.com, sachin.kamat@linaro.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Thu, 19 Jun 2014 14:13:39 -0700
In-Reply-To: <53A35062.7070705@gmail.com>
References: <53A35062.7070705@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 23:04 +0200, Federico Di Pierro wrote:
> This is a very small patch that fixes 3 little coding style problems.
> I'm using linux-next.

Hello Federico.

Your patch is word wrapped and can't be applied.

Please read Documentation/SubmittingPatches and
Documentation/email-clients.txt

Ideally, try to use git, git format-patch and
git send-email.

> --- linux/drivers/staging/iio/frequency/ad9832.c.orig	2014-06-02 
> 17:26:12.929978122 +0200
> +++ linux/drivers/staging/iio/frequency/ad9832.c	2014-06-02 
> 19:34:57.129506826 +0200



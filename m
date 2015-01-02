Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbbABXHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 18:07:45 -0500
Received: from smtprelay0130.hostedemail.com ([216.40.44.130]:60318 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752253AbbABXHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 18:07:44 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3873:3874:4250:4321:4605:5007:6261:7903:10004:10400:10848:11232:11657:11658:11914:12043:12517:12519:12740:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ant20_8feda9a44a46
X-Filterd-Recvd-Size: 1600
Message-ID: <1420240060.23591.4.camel@perches.com>
Subject: Re: [PATCH 1/2] Staging: comedi: tab space coding style issue in
 pcl818.c
From: Joe Perches <joe@perches.com>
To: jitendra kumar khasdev <jkhasdev@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, pankaj.saraf@nektech.in
Date: Fri, 02 Jan 2015 15:07:40 -0800
In-Reply-To: <1420223689-23586-1-git-send-email-jkhasdev@gmail.com>
References: <1420223689-23586-1-git-send-email-jkhasdev@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2015-01-03 at 00:04 +0530, jitendra kumar khasdev wrote:
> This is patch to the pcl818.c that fix up a use tab error
> found by the checkpatch.pl tool
[]
> diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
[]
> @@ -45,7 +45,7 @@ A word or two about DMA. Driver support DMA operations at two ways:
>      [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
>      [2] - DMA	(0=disable, 1, 3)
>      [3] - 0, 10=10MHz clock for 8254
> -              1= 1MHz clock for 8254
> +		1= 1MHz clock for 8254

Please look at the end result and determine
if what you've done is better or worse than
the original.



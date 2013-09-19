Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab3ISWK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 18:10:27 -0400
Received: from smtprelay0240.hostedemail.com ([216.40.44.240]:32862 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753559Ab3ISWK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 18:10:26 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:4321:5007:7652:8603:10004:10400:10848:11657:11658:11914:12043:12517:12519:12740:13069:13071:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sheet93_5ad0e1ca49529
X-Filterd-Recvd-Size: 1502
Message-ID: <1379628622.5862.5.camel@joe-AO722>
Subject: Re: [PATCH 2/10] xtensa: Cocci spatch "noderef"
From: Joe Perches <joe@perches.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: chris@zankel.net, jcmvbkbc@gmail.com, linux-xtensa@linux-xtensa.org,
        linux-kernel@vger.kernel.org
Date: Thu, 19 Sep 2013 15:10:22 -0700
In-Reply-To: <1379604755851-2004428468-2-diffsplit-thomas@m3y3r.de>
References: <1379604755850-858421494-0-diffsplit-thomas@m3y3r.de>
	 <1379604755851-2004428468-2-diffsplit-thomas@m3y3r.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-19 at 23:42 +0200, Thomas Meyer wrote:
> sizeof when applied to a pointer typed expression gives the size of the
> pointer.

Hi Thomas, thanks for doing the series...

> diff -u -p a/arch/xtensa/platforms/iss/network.c b/arch/xtensa/platforms/iss/network.c
[]
> @@ -737,7 +737,7 @@ static int __init iss_net_setup(char *st
>  		return 1;
>  	}
>  
> -	if ((new = alloc_bootmem(sizeof new)) == NULL) {
> +	if ((new = alloc_bootmem(sizeof *new)) == NULL) {

sizeof(*new)

Please run coccinelle generated patches through checkpatch
(and the compiler of course) before submitting them.



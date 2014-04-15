Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaDOFvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 01:51:12 -0400
Received: from smtprelay0043.hostedemail.com ([216.40.44.43]:58518 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750875AbaDOFvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 01:51:10 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:4321:5007:6117:6642:7652:10004:10400:10848:11658:11914:12043:12296:12517:12519:12683:12740:13069:13311:13357:14110,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: smash77_9bf0e8f2d829
X-Filterd-Recvd-Size: 1434
Message-ID: <1397541065.16090.11.camel@joe-AO722>
Subject: Re: [PATCH v5 1/6] SP800-90A Deterministic Random Bit Generator
From: Joe Perches <joe@perches.com>
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        aquini@redhat.com, jeremy.wayne.powell@gmail.com, clemens@ladisch.de,
        pwalten@au1.ibm.com
Date: Mon, 14 Apr 2014 22:51:05 -0700
In-Reply-To: <1635225.UnHjb6h9ND@myon.chronox.de>
References: <2396177.vxvG2ljJL8@myon.chronox.de>
	 <1952806.u8ySj6rIyr@myon.chronox.de> <3972168.arX3qfUzsN@myon.chronox.de>
	 <1635225.UnHjb6h9ND@myon.chronox.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-15 at 07:35 +0200, Stephan Mueller wrote:
> diff --git a/crypto/drbg.c b/crypto/drbg.c
[]
> @@ -0,0 +1,1997 @@
[]
> +/***************************************************************
> + * Backend cipher definitions available to DRBG
> + ***************************************************************/
> +
> +const struct drbg_core cores[] = {

cores isn't a very good global name.
I presume this should be static.



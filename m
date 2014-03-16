Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbaCPTVl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 15:21:41 -0400
Received: from smtprelay0126.hostedemail.com ([216.40.44.126]:46040 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752178AbaCPTVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 15:21:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3866:3870:3874:4321:4605:5007:7652:9121:10004:10400:10848:11232:11233:11658:11914:12043:12262:12296:12438:12517:12519:12555:12679:12740:13069:13141:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gate25_65987bf53c534
X-Filterd-Recvd-Size: 1859
Message-ID: <1394997694.5689.58.camel@joe-AO722>
Subject: Re: [PATCH] Staging: gdm724x: gdm_lte.h: fixed coding style
From: Joe Perches <joe@perches.com>
To: Daniel Ngu <daniel.dy.ngu@gmail.com>
Cc: Jonathan Kim <jonathankim@gctsemi.com>, Dean ahn <deanahn@gctsemi.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sun, 16 Mar 2014 12:21:34 -0700
In-Reply-To: <20140316191817.GD3478@quad>
References: <20140316191817.GD3478@quad>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-17 at 08:18 +1300, Daniel Ngu wrote:
> Missing space after return type

Not really.

> diff --git a/drivers/staging/gdm724x/gdm_lte.h b/drivers/staging/gdm724x/gdm_lte.h
[]
> @@ -56,7 +56,7 @@ struct phy_dev {
>  			int (*cb)(void *cb_data, void *data, int len,
>  				  int context),
>  			void *cb_data, int context);
> -	struct gdm_endian *(*get_endian)(void *priv_dev);
> +	struct gdm_endian * (*get_endian)(void *priv_dev);

That one was a defect in checkpatch that was
corrected in -next by:

commit 93ca9441419b0bfbf96243e01f39b5a80565215e
Author: Joe Perches <joe@perches.com>
Date:   Thu Mar 6 11:02:08 2014 +1100

    checkpatch: don't warn on some function pointer return styles
    
    Checks for some function pointer return styles are too strict.  Fix them.
    
    Multiple spaces after function pointer return types are allowed.
        int  (*foo)(int bar)
    
    Spaces after function pointer returns of pointer types are not required.
        int *(*foo)(int bar)



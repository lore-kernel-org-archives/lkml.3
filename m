Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaBJGHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 01:07:09 -0500
Received: from smtprelay0229.hostedemail.com ([216.40.44.229]:57516 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750835AbaBJGHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 01:07:07 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3870:3871:4321:5007:7652:10004:10400:10848:11232:11657:11658:11914:12043:12296:12517:12519:12740:13069:13071:13095:13141:13161:13229:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: queen09_3dcc20755ca3c
X-Filterd-Recvd-Size: 1468
Message-ID: <1392012424.3178.23.camel@joe-AO722>
Subject: Re: [PATCH] staging : ion : Fix some checkpatch warnings and an
 error
From: Joe Perches <joe@perches.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, swetland@google.com, john.stultz@linaro.org,
        rebecca@android.com, ccross@android.com, ohaugan@codeaurora.org,
        romlem@google.com, linux-kernel@vger.kernel.org,
        devel <devel@driverdev.osuosl.org>
Date: Sun, 09 Feb 2014 22:07:04 -0800
In-Reply-To: <81912500.jvGoQpGOq5@daeseok-laptop.cloud.net>
References: <81912500.jvGoQpGOq5@daeseok-laptop.cloud.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 14:56 +0900, Daeseok Youn wrote:
>

Hello.

> diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
[]
> -	struct sg_table *(*map_dma) (struct ion_heap *heap,
> +	struct sg_table * (*map_dma)(struct ion_heap *heap,

The message about space required after "struct sg_table *"
is a checkpatch defect.  This is better as:

	struct sg_table *(*map_dma)(struct ion_heap *heap, etc...)

I'll fix checkpatch in a little bit.



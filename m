Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbaI3Gfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 02:35:52 -0400
Received: from smtprelay0131.hostedemail.com ([216.40.44.131]:33112 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751715AbaI3Gfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 02:35:50 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:1801:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3867:3868:3870:3872:3873:3874:4321:4605:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fruit84_8a0580964475e
X-Filterd-Recvd-Size: 1592
Message-ID: <1412058947.4302.88.camel@joe-AO725>
Subject: Re: [PATCH v2 2/4] staging: skein: Additional Whitespace Issues
From: Joe Perches <joe@perches.com>
To: Eric Rost <eric.rost@mybabylon.net>
Cc: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 29 Sep 2014 23:35:47 -0700
In-Reply-To: <86fca4750dfba1c25d7d8b3b5cb5f019e756fed7.1412056800.git.eric.rost@mybabylon.net>
References: <cover.1412056799.git.eric.rost@mybabylon.net>
	 <86fca4750dfba1c25d7d8b3b5cb5f019e756fed7.1412056800.git.eric.rost@mybabylon.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-30 at 01:10 -0500, Eric Rost wrote:
> Fixes leading and trailing whitespace issues.
[]
> diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
[]
> @@ -36,7 +36,7 @@
>  #define debug_save_tweak(ctx)       \
>  {                                   \
>  	ctx->h.tweak[0] = ts[0];    \
> -       	ctx->h.tweak[1] = ts[1];    \
> +	ctx->h.tweak[1] = ts[1];    \

I know it's an extra step to reintegrate these, but
please don't introduce whitespace problems in patch 1
that you fix in patch 2.

Do it correctly in patch 1.



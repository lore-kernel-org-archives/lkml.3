Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaIJHXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 03:23:22 -0400
Received: from smtprelay0121.hostedemail.com ([216.40.44.121]:46469 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750937AbaIJHXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 03:23:20 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3866:3867:3874:4321:5007:7652:7903:10004:10400:10848:11026:11658:11914:12438:12517:12519:12740:13069:13161:13229:13311:13357:13894:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: start28_742f1533e8e00
X-Filterd-Recvd-Size: 1493
Message-ID: <1410333797.24028.29.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: struct of_device_id should usually be const
From: Joe Perches <joe@perches.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Date: Wed, 10 Sep 2014 00:23:17 -0700
In-Reply-To: <1410333346-29062-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1410333346-29062-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-10 at 09:15 +0200, Uwe Kleine-König wrote:
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -4941,6 +4941,7 @@ sub process {
>  				mtrr_ops|
>  				neigh_ops|
>  				nlmsvc_binding|
> +				of_device_id|
>  				pci_raw_ops|
>  				pipe_buf_operations|
>  				platform_hibernation_ops|

Fine by me, there are ~1200 or so const uses.

There are also ~350 of these that are not const.

Are most all of those supposed to be const?


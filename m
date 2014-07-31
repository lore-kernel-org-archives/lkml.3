Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaGaWlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:41:55 -0400
Received: from smtprelay0234.hostedemail.com ([216.40.44.234]:47230 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750906AbaGaWly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:41:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:960:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3872:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12555:12740:13069:13071:13311:13357:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shop53_4a76653af7e17
X-Filterd-Recvd-Size: 1751
Message-ID: <1406846509.9953.6.camel@joe-AO725>
Subject: Re: [PATCH 0/8] staging: iio: accel: multiple coding style fixes
From: Joe Perches <joe@perches.com>
To: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        jic23@kernel.org
Date: Thu, 31 Jul 2014 15:41:49 -0700
In-Reply-To: <1406846098-19866-1-git-send-email-mopsfelder@gmail.com>
References: <1406846098-19866-1-git-send-email-mopsfelder@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-31 at 19:34 -0300, Murilo Opsfelder Araujo wrote:
> The following patches fix (almost) all warnings reported by
> checkpatch.pl.
> 
> Murilo Opsfelder Araujo (8):
>   staging: iio: accel: adis16203_core.c: fix coding style
>   staging: iio: accel: adis16201_core.c: fix coding style
>   staging: iio: accel: adis16204_core.c: fix coding style
>   staging: iio: accel: adis16209_core.c: fix coding style
>   staging: iio: accel: adis16240_core.c: fix coding style
>   staging: iio: accel: lis3l02dq_core.c: fix coding style
>   staging: iio: accel: lis3l02dq_ring.c: fix coding style
>   staging: iio: accel: sca3000_core.c: fix coding style

Hi.

Next time it might be better to use patch subjects like

staging: <subsystem> Add blank lines between declarations and code

because "fix coding style" really isn't very descriptive.


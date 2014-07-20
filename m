Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbaGTBLX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 21:11:23 -0400
Received: from smtprelay0058.hostedemail.com ([216.40.44.58]:50620 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751521AbaGTBLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 21:11:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:7652:7903:10004:10400:10848:11232:11657:11658:11914:12043:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: kiss31_62d62a49df413
X-Filterd-Recvd-Size: 1578
Message-ID: <1405818675.5135.3.camel@joe-AO725>
Subject: Re: [PATCH 1/1] Staging: comedi: 8255.c Missing a blank line fixed
From: Joe Perches <joe@perches.com>
To: Sam Asadi <asadi.samuel@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sat, 19 Jul 2014 18:11:15 -0700
In-Reply-To: <1405816991-8749-1-git-send-email-asadi.samuel@gmail.com>
References: <1405816991-8749-1-git-send-email-asadi.samuel@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-20 at 03:43 +0300, Sam Asadi wrote:
> A 'Missing a blank line after declarations' issue fixed and also tested
> by 'make M=...'. It seems that after 'unsigned long iobase' declaration
> a blank line is desperately needed.
[]
> diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
[]
> @@ -94,6 +94,7 @@ I/O port base address can be found in the output of 'lspci -v'.
>  
>  struct subdev_8255_private {
>  	unsigned long iobase;
> +
>  	int (*io)(int, int, int, unsigned long);
>  };
>  

You used an old version of checkpatch without a
modification to the "blank line after declarations"
test that supports function pointers.

Use the latest version from --next instead.


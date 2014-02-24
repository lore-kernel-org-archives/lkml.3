Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaBXIxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:53:41 -0500
Received: from smtprelay0053.hostedemail.com ([216.40.44.53]:44087 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751326AbaBXIxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:53:39 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3871:4321:4605:5007:7652:7904:10004:10400:10848:11232:11657:11658:11914:12043:12296:12517:12519:12679:12740:13069:13095:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: net68_29306edab104
X-Filterd-Recvd-Size: 1845
Message-ID: <1393232015.11020.25.camel@joe-AO722>
Subject: Re: [PATCH] Staging: comedi: Fix coding style issue in poc.c
From: Joe Perches <joe@perches.com>
To: David Roddick <dgroddick@gmail.com>
Cc: gregkh@linuxfoundation.org, abbotti@mev.co.uk,
        hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 24 Feb 2014 00:53:35 -0800
In-Reply-To: <1393231142-2227-1-git-send-email-dgroddick@gmail.com>
References: <1393231142-2227-1-git-send-email-dgroddick@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-24 at 19:39 +1100, David Roddick wrote:
> This is a patch to remove unneccessary space after function pointer name found with checkpatch.pl 

A few comments:

Please wrap your commit message to 70 columns or so.

There is 1 c in unnecessary.

The "This is a patch to " bit isn't particularly useful in
the commit log, neither is the "found with checkpatch.pl".

> diff --git a/drivers/staging/comedi/drivers/poc.c b/drivers/staging/comedi/drivers/poc.c
[]
> @@ -36,15 +36,15 @@ Configuration options:
[]
> -	int (*winsn) (struct comedi_device *, struct comedi_subdevice *,
> +	int (*winsn)(struct comedi_device *, struct comedi_subdevice *,
>  		      struct comedi_insn *, unsigned int *);

Please wrap multi-line definitions lines like:

	int (*winsn)(struct comedi_device *, struct comedi_subdevice *,
		     struct comedi_insn *, unsigned int *);

Ideally, these arguments would have some descriptive names
too.



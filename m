Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbaHFCfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 22:35:43 -0400
Received: from smtprelay0060.hostedemail.com ([216.40.44.60]:45562 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755606AbaHFCfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 22:35:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3871:3872:4321:5007:7652:7875:7903:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13137:13150:13230:13231:13311:13357:14039:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: burn41_4ec2f5288fc44
X-Filterd-Recvd-Size: 1671
Message-ID: <1407292539.16152.118.camel@joe-AO725>
Subject: Re: [PATCH] staging: comedi: drivers.c: fix checkpatch code style
 issue
From: Joe Perches <joe@perches.com>
To: Dzonatans Melgalvis <dz.melgalvis@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Tue, 05 Aug 2014 19:35:39 -0700
In-Reply-To: <1407286422-19733-1-git-send-email-dz.melgalvis@gmail.com>
References: <1407286422-19733-1-git-send-email-dz.melgalvis@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-06 at 03:53 +0300, Dzonatans Melgalvis wrote:
> Fixing checkpatch warning - blank line missing after declaration.
[]
> diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
[]
> @@ -440,6 +440,7 @@ static void *comedi_recognize(struct comedi_driver *driv, const char *name)
>  static void comedi_report_boards(struct comedi_driver *driv)
>  {
>  	unsigned int i;
> +
>  	const char *const *name_ptr;
>  
>  	pr_info("comedi: valid board names for %s driver are:\n",

This is also a false positive from an old version
of checkpatch.

For all messages produced by brainless tools,
please use your skill, experience, and taste and
look at what is being suggested and see if it's
right before sending patches based on the tools
suggestions.


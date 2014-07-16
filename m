Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934289AbaGPNO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:14:28 -0400
Received: from smtprelay0238.hostedemail.com ([216.40.44.238]:52812 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934260AbaGPNOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:14:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3280:3622:3865:3868:3870:4321:5007:7652:7903:9040:10004:10400:10848:11026:11657:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dress88_434acad754505
X-Filterd-Recvd-Size: 1518
Message-ID: <1405516454.14773.70.camel@joe-AO725>
Subject: Re: [PATCH] Staging: comedi: adl_pci9118: a style issue fixed
From: Joe Perches <joe@perches.com>
To: Sam Asadi <asadi.samuel@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 16 Jul 2014 06:14:14 -0700
In-Reply-To: <1405513452-7628-1-git-send-email-asadi.samuel@gmail.com>
References: <1405513452-7628-1-git-send-email-asadi.samuel@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-16 at 15:24 +0300, Sam Asadi wrote:
> 'quoted string split across lines' warning in checkpatching fixed
> by group whole string in one line.
[]
> diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
[]
> @@ -412,8 +412,7 @@ static int check_channel_list(struct comedi_device *dev,
> 			if ((CR_AREF(chanlist[i]) == AREF_DIFF) !=
> 			    (differencial)) {
> 				comedi_error(dev,
> -					     "Differencial and single ended "
> -						"inputs can't be mixtured!");
> +					     "Differencial and single ended inputs can't be mixtured!");

Might as well fix the fractured misspellings too.



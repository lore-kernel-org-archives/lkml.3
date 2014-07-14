Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaGNIGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:06:18 -0400
Received: from smtprelay0097.hostedemail.com ([216.40.44.97]:59071 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750943AbaGNIGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:06:11 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:196:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1566:1593:1594:1622:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2904:3138:3139:3140:3141:3142:3622:3870:3876:4321:5007:7514:7576:7652:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rub64_18823344ec617
X-Filterd-Recvd-Size: 1570
Message-ID: <1405325166.9132.40.camel@joe-AO725>
Subject: Re: [PATCH net-next v2 3/6] ethernet: amd: dynamic debug fixes
From: Joe Perches <joe@perches.com>
To: varkabhadram@gmail.com
Cc: netdev@vger.kernel.org, Thomas.Lendacky@amd.com,
        geert+renesas@linux-m68k.org, ebiederm@xmission.com,
        macro@linux-mips.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, Varka Bhadram <varkab@cdac.in>
Date: Mon, 14 Jul 2014 01:06:06 -0700
In-Reply-To: <1405319147-5212-4-git-send-email-varkabhadram@gmail.com>
References: <1405319147-5212-1-git-send-email-varkabhadram@gmail.com>
	 <1405319147-5212-4-git-send-email-varkabhadram@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-14 at 11:55 +0530, varkabhadram@gmail.com wrote:
> From: Varka Bhadram <varkab@cdac.in>
[]
> diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
[]
> @@ -501,8 +501,7 @@ static int amd8111e_restart(struct net_device *dev)
>  
>  	/* Enable interrupt coalesce */
>  	if(lp->options & OPTION_INTR_COAL_ENABLE){
> -		printk(KERN_INFO "%s: Interrupt Coalescing Enabled.\n",
> -								dev->name);
> +		netdev_info(dev, "Interrupt Coalescing Enabled");

This needs a terminating newlines.



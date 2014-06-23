Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbaFWQi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:38:58 -0400
Received: from smtprelay0060.hostedemail.com ([216.40.44.60]:33004 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756013AbaFWQi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:38:57 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3874:4321:5007:6119:7652:10004:10400:10848:11026:11232:11658:11914:12043:12114:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dime56_4d72a82463160
X-Filterd-Recvd-Size: 1771
Message-ID: <1403541530.15811.1.camel@joe-AO725>
Subject: Re: [PATCH] stable_kernel_rules: Add pointer to netdev-FAQ for
 network patches
From: Joe Perches <joe@perches.com>
To: Dave Chiluk <chiluk@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Date: Mon, 23 Jun 2014 09:38:50 -0700
In-Reply-To: <1403540548-17152-1-git-send-email-chiluk@canonical.com>
References: <1403540548-17152-1-git-send-email-chiluk@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 11:22 -0500, Dave Chiluk wrote:
> Stable_kernel_rules should point submitters of network stable patches to the
> netdev_FAQ.txt as requests for stable network patches should go to netdev
> first.
[]
> diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
[]
> @@ -29,6 +29,9 @@ Rules on what kind of patches are accepted, and which ones are not, into the
>  
>  Procedure for submitting patches to the -stable tree:
>  
> + - If the patch covers the networking subsystem please follow netdev stable
> +   sumissision guidelines as described in
> +   Documentation/networking/netdev-FAQ.txt

Perhaps that should state net/ and drivers/net/ rather
than the networking subsystem which people might not
associate with the drivers.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaJFWE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 18:04:29 -0400
Received: from smtprelay0076.hostedemail.com ([216.40.44.76]:49874 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750956AbaJFWE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 18:04:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3874:4321:5007:6691:7576:7652:10004:10400:10848:10967:11232:11658:11914:12517:12519:12740:13018:13019:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: patch44_99d406c83f2c
X-Filterd-Recvd-Size: 1632
Message-ID: <1412633064.2916.46.camel@joe-AO725>
Subject: Re: [PATCH net-next] net: core: Quiet W=1 warnings for unused vars
 and static functions
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.fastabend@gmail.com
Date: Mon, 06 Oct 2014 15:04:24 -0700
In-Reply-To: <20141006.175612.1709169088283433326.davem@davemloft.net>
References: <1412632298.2916.42.camel@joe-AO725>
	 <20141006.175612.1709169088283433326.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-06 at 17:56 -0400, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Mon, 06 Oct 2014 14:51:38 -0700
> 
> > Reduce noise when compiling W=1.
[]
> BTW, this patch reminds me that if people think there are
> subdirectories where we can turn on things like -Werror in the
> networking I would be very happy to apply such patches.
[]
> Things like net/core/ for example should be doable for sure.

I don't have any significant opposition to -Werror, but
I think there are real arguments _against_ using -Werror.

I think the primary one is new compiler versions have a
tendency to add new warnings for various things that can
unnecessarily and unpredictably break the build.





Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaBGFLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 00:11:38 -0500
Received: from smtprelay0091.hostedemail.com ([216.40.44.91]:33547 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750787AbaBGFLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 00:11:36 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13071:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: elbow88_81f9690c7fe05
X-Filterd-Recvd-Size: 1751
Message-ID: <1391749891.15777.31.camel@joe-AO722>
Subject: Re: [PATCH v5 00/14] Add support for MSM's mmio clock/reset
 controller
From: Joe Perches <joe@perches.com>
To: frowand.list@gmail.com
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Saravana Kannan <skannan@codeaurora.org>
Date: Thu, 06 Feb 2014 21:11:31 -0800
In-Reply-To: <52F45DEE.8020400@gmail.com>
References: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>
	 <52F45DEE.8020400@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-06 at 20:15 -0800, Frank Rowand wrote:
> On 1/15/2014 10:47 AM, Stephen Boyd wrote:
> > The first breaks a reset-controller include ordering requirement. It got
> > an ack so I think we're ok for it to go through the clock tree.
> > 
> 
> < snip >
> 
> checkpatch is whining about patches
> 
>   4
>   5
>   6
>   7
>   8
> 
> (Just for completeness if someone thinks I did not check all the patches,
> it also whines about patch 11, but I think the whining should be ignored,
> and it whines about patch 1 but I think that might be a checkpatch bug.)

Hi Frank.

For patch 1, what checkpatch bug might that be?

I think all the checkpatch whinges in patch 11 are correct.

I didn't check any of 4-8.



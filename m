Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbaIED64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 23:58:56 -0400
Received: from smtprelay0222.hostedemail.com ([216.40.44.222]:35647 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751999AbaIED6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 23:58:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:2840:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6119:6120:7652:7901:7903:8531:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13149:13230:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cave69_4da08f64bb857
X-Filterd-Recvd-Size: 2111
Message-ID: <1409889532.2770.30.camel@joe-AO725>
Subject: Re: [PATCH] kernel: add support for gcc 5
From: Joe Perches <joe@perches.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, akpm@linuxfoundation.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Sep 2014 20:58:52 -0700
In-Reply-To: <54092FE0.3030004@oracle.com>
References: <1409845039-5751-1-git-send-email-sasha.levin@oracle.com>
	 <20140904212535.GA5059@drone.musicnaut.iki.fi>
	 <1409870628.2310799.163815377.623F33D2@webmail.messagingengine.com>
	 <1409874455.2770.26.camel@joe-AO725> <54092FE0.3030004@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-04 at 23:37 -0400, Sasha Levin wrote:
> On 09/04/2014 07:47 PM, Joe Perches wrote:
> > On Fri, 2014-09-05 at 00:43 +0200, Hannes Frederic Sowa wrote:
> >> > Most statements are already depending on GCC_VERSION, maybe we can just
> >> > unify all gcc specific headers to one, still trying to keep the file
> >> > organized? ;)
> > Maybe something like:
> > 
> > gnu development of gcc will be more frequent and the use of
> > compiler-gcc<major>.h likely will not be convenient anymore.
> > 
> > Integrate the individual compiler-gcc<major>.h files into
> > compiler-gcc.h.
> 
> Please no. We have a similar file we maintain in our team that's supposed to
> do something very similar for kernel versions. It goes all the way back to
> 2.6.9 and it's a *horrible* mess.
> 
> This is how compiler-gcc.h will end up looking in a while.

As gcc options are generally upward compatible,
I don't think it will but there's no great way
to predict the future.

It wouldn't be as complicated as say backports.



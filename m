Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaJOS40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 14:56:26 -0400
Received: from smtprelay0083.hostedemail.com ([216.40.44.83]:55505 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751654AbaJOS4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 14:56:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3868:3871:3873:3874:4321:5007:6261:10004:10400:10450:10455:10848:11232:11658:11914:12517:12519:12663:12740:13069:13311:13357:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: team61_377479c54192f
X-Filterd-Recvd-Size: 1966
Message-ID: <1413399379.7484.5.camel@perches.com>
Subject: Re: [PATCH] bcm/CmHost.c: Fix noisy compile warnings
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Fabio Estevam <festevam@gmail.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 15 Oct 2014 11:56:19 -0700
In-Reply-To: <1413399256.2412.27.camel@jtkirshe-mobl>
References: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <20141015123431.GA23154@mwanda> <20141015125934.GB23154@mwanda>
	 <1413378213.2412.13.camel@jtkirshe-mobl>
	 <1413389496.7484.3.camel@perches.com>
	 <1413394958.2412.23.camel@jtkirshe-mobl>
	 <CAOMZO5C5ya=OgBUEOOM+tZE7B2zZ3J05PHC14t3Tp6nXkPYmoQ@mail.gmail.com>
	 <1413399256.2412.27.camel@jtkirshe-mobl>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-15 at 11:54 -0700, Jeff Kirsher wrote:
> On Wed, 2014-10-15 at 15:24 -0300, Fabio Estevam wrote:
> > On Wed, Oct 15, 2014 at 2:42 PM, Jeff Kirsher
> > <jeffrey.t.kirsher@intel.com> wrote:
> > 
> > > I like the idea, but won't this exclude other 32 bit systems like MIPS
> > > and I am sure there might be others.  I could assume that Beceem WIMAX
> > > was intended for x86 arch's that are 32 bit only, which may be a safe
> > > bet.  The only thing we know for sure is that is broken on 64bit.
> > 
> > What about this?
> 
> That works for me.  I am putting together a v2 patch now, since you came
> up with the change, I will put you as the author Fabio, ok?

Good idea.



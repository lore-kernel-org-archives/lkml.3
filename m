Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbaIHPc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:32:59 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51198 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753590AbaIHPcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:32:54 -0400
X-Sasl-enc: GUZamEiHC2Mt1gHBQSuh9ZywLZgv3WhsmESomNcKnBCO 1410189995
Date: Mon, 8 Sep 2014 08:26:34 -0700
From: Greg KH <greg@kroah.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Francis Moreau <francis.moro@gmail.com>,
        Kent Overstreet <kmo@daterainc.com>, Peter Kieser <peter@kieser.ca>,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] bcache changes for 3.17
Message-ID: <20140908152634.GA32677@kroah.com>
References: <20140805043346.GF541@moria.home.lan>
 <53E10D48.1010700@kernel.dk>
 <53E7251B.3080305@kieser.ca>
 <540966BA.9030106@gmail.com>
 <20140905214532.GA30221@kroah.com>
 <540A377C.2000901@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540A377C.2000901@kernel.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 04:21:48PM -0600, Jens Axboe wrote:
> On 09/05/2014 03:45 PM, Greg KH wrote:
> > On Fri, Sep 05, 2014 at 09:31:06AM +0200, Francis Moreau wrote:
> >> On 08/10/2014 09:54 AM, Peter Kieser wrote:
> >>>
> >>> On 2014-08-05 9:58 AM, Jens Axboe wrote:
> >>>> On 08/04/2014 10:33 PM, Kent Overstreet wrote:
> >>>>> Hey Jens, here's the pull request for 3.17 - typically late, but lots of tasty
> >>>>> fixes in this one :)
> >>>> Normally I'd say no, but since it's basically just fixes, I guess we can
> >>>> pull it in. But generally, it has to be in my hands a week before this,
> >>>> so it can simmer a bit in for-next before going in...
> >>>>
> >>> Are these fixes going to be backported to 3.10 or other stable releases?
> >>>
> >>
> >> Could you please answer this question ?
> >>
> >> If you don't want to maintain bcache for stable kernels (I can
> >> understand that), can you mark it at least as unstable/experimental
> >> stuff since it really is ?
> > 
> > WTF?
> > 
> > Just because a maintainer/developer doesn't want to do anything for the
> > stable kernel releases does _NOT_ mean the code is
> > "unstable/expreimental" at all.
> 
> That's not what he is saying at all. The code IS unstable in 3.10. And
> the fact that nothing goes to stable for bcache, the situation wasn't
> likely to change for 3.10. Nobody is saying "Oh nothing goes to stable,
> lets mark it experimental".

Sorry, but with only the context above which is what I was sent, you can
see how I can be confused here...

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138AbaAJCUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 21:20:00 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:52331 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaAJCT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 21:19:58 -0500
Date: Fri, 10 Jan 2014 11:19:54 +0900
From: Simon Horman <horms@verge.net.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-sh@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Paul Mundt <lethal@linux-sh.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bastian Hecht <hechtb@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: linux-next: manual merge of the sh tree with the tree
Message-ID: <20140110021954.GB14912@verge.net.au>
References: <20140106121317.bada4233ec3fec40f79735cc@canb.auug.org.au>
 <CAOesGMgJe9KR2muA4F9EaXYpDFDLxVZsKOj-8qZFbDZTiRBuww@mail.gmail.com>
 <20140110004724.GA22965@verge.net.au>
 <20140110125529.9843f450bf79223164031b02@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140110125529.9843f450bf79223164031b02@canb.auug.org.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC Magnus]

On Fri, Jan 10, 2014 at 12:55:29PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> On Fri, 10 Jan 2014 09:47:24 +0900 Simon Horman <horms@verge.net.au> wrote:
> >
> > On Wed, Jan 08, 2014 at 11:11:03PM -0800, Olof Johansson wrote:
> > >
> > > The request to merge the sh code came through Simon with claimed
> > > agreement from SH maintainers to do so -- I didn't verify this since
> > > they have in the past been well-coordinated. Simon?
> > 
> > I spoke with Paul recently and my understanding is that
> > he hasn't been actively working in this area for over a year now.
> > 
> > I guess there are some stale patches in his tree.
> 
> That is certainly what it looks like.  So, do I remove the sh{,.-current)
> trees (git://github.com/pmundt/linux-sh.git#sh-{latest,fixes-for-linus})
> from linux-next permanently?  Will it be cleaned up any time soon?

I think that removing it would be a good choice.

> Is anyone maintaining/supporting sh now?  Is it a candidate for pruning?

Its a topic of discussion at Renesas. And I hope that someone
will be doing some form of maintenance again soon.


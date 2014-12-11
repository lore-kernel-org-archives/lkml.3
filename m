Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965512AbaLKXqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 18:46:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933361AbaLKXqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 18:46:17 -0500
Date: Fri, 12 Dec 2014 01:45:42 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ben@decadent.org.uk,
        cornelia.huck@de.ibm.com, jasowang@redhat.com, pbonzini@redhat.com,
        rusty@rustcorp.com.au, sergei.shtylyov@cogentembedded.com,
        thuth@linux.vnet.ibm.com, David Miller <davem@davemloft.net>
Subject: Re: [PULL] virtio: virtio 1.0 support, misc patches
Message-ID: <20141211234542.GA9439@redhat.com>
References: <20141211120248.GA8838@redhat.com>
 <20141212080705.50988d51@canb.auug.org.au>
 <20141211220157.GA22618@redhat.com>
 <20141212102426.187891e9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141212102426.187891e9@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 10:24:26AM +1100, Stephen Rothwell wrote:
> Hi Michael,
> 
> On Fri, 12 Dec 2014 00:01:57 +0200 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> >
> > It was on linux next for a while, then I wanted to tweak the commit log
> > for some messages a bit.
> > So since I rewrote the history anyway, I went ahead and rebased it
> > on v3.18, after this rebase it's been in linux-next for several days.
> 
> Maybe you think you pushed it into a linux-next included branch (or
> maybe you think I am fetching a branch that I am not),

Oh.  I thought linux-next is pulling vhost-next, when in fact
it turns out it's pulling it's own linux-next branch.

So it looks like I didn't update that branch in a while - now I see
why it's a bit so quiet.

It's probably best to keep it at linux-next branch, as it is:
I've tweaked my push rules to update that branch now, and pushed
again.

Thanks a lot for letting me know!


> but when I look
> at those commits in my tree (as I fetch Linus' tree into mine) none of
> them precede any of the next-* tags ...
> 
> I am not doubting that these patches have been published and reviewed
> and tested, all I am saying is that they have not been in linux-next
> as those commits.

You are right of course.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965428AbaLKWCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:02:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933939AbaLKWCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:02:39 -0500
Date: Fri, 12 Dec 2014 00:01:57 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ben@decadent.org.uk,
        cornelia.huck@de.ibm.com, jasowang@redhat.com, pbonzini@redhat.com,
        rusty@rustcorp.com.au, sergei.shtylyov@cogentembedded.com,
        thuth@linux.vnet.ibm.com, David Miller <davem@davemloft.net>
Subject: Re: [PULL] virtio: virtio 1.0 support, misc patches
Message-ID: <20141211220157.GA22618@redhat.com>
References: <20141211120248.GA8838@redhat.com>
 <20141212080705.50988d51@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141212080705.50988d51@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 08:07:05AM +1100, Stephen Rothwell wrote:
> Hi Michael,
> 
> On Thu, 11 Dec 2014 14:02:48 +0200 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> >
> > The following changes since commit b2776bf7149bddd1f4161f14f79520f17fc1d71d:
> > 
> >   Linux 3.18 (2014-12-07 14:21:05 -0800)
> 
> hmmm ...
> 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> > 
> > for you to fetch changes up to 803cd18f7b5e6c7ad6bee9571ae8f4450190ab58:
> > 
> >   virtio_ccw: finalize_features error handling (2014-12-09 16:32:41 +0200)
> > 
> > Note: some net drivers are affected by these patches.
> > David said he's fine with merging these patches through
> > my tree.
> > Rusty's on vacation, he acked using my tree for these, too.
> 
> So, either none of this has been in linux-next or you have just rebased
> it all on top of v3.18 ...

It was on linux next for a while, then I wanted to tweak the commit log
for some messages a bit.
So since I rewrote the history anyway, I went ahead and rebased it
on v3.18, after this rebase it's been in linux-next for several days.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



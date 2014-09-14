Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaINGSF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 02:18:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbaINGSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 02:18:04 -0400
Date: Sun, 14 Sep 2014 09:21:17 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: Rusty away 18th September -- 11th October
Message-ID: <20140914062116.GA23868@redhat.com>
References: <87oaunht4b.fsf@rustcorp.com.au>
 <20140911114351.GA25736@redhat.com>
 <87tx4dhbks.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tx4dhbks.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 10:58:03AM +0930, Rusty Russell wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> > On Thu, Sep 11, 2014 at 10:26:52AM +0930, Rusty Russell wrote:
> >> Hi all,
> >> 
> >>         Probably won't read mail.  Linus, I'll have pull requests early
> >> next week; if there's anything needed I'm sure Michael Tsirkin can
> >> handle it.
> >
> > Sure.
> > Rusty, there's a small chance virtio 1.0 bits will be ready in time.
> > I started working on them based on your virtio-pci-new-layout branch.
> >
> > If ready before the merge window, are you ok with me merging this
> > support (without you having the opportunity to review first)?
> 
> Sorry, absolutely not.  I *really* want to review this in depth; if we
> make a mistake, it's going to hurt us significantly.

Right but it's only a merge window - we can fix bugs and even disable
the new driver afterwards, can't we?

> And until we have the qemu bits ready, it's really hard to tell if we've
> got this right.

Sure, I meant if qemu bits are ready too, and if things work together.
It wouldn't do to merge a driver that isn't ready.


>  So I'd rather delay and make sure we're solid.
> 
> Thanks,
> Rusty.

Something else we can do, is refactoring that splits driver
out to common and legacy bits, and changes APIs.
No?

-- 
MSt

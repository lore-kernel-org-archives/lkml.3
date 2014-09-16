Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbaIPPym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:54:42 -0400
Received: from ozlabs.org ([103.22.144.67]:36221 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023AbaIPPyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:54:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: Rusty away 18th September -- 11th October
In-Reply-To: <20140914062116.GA23868@redhat.com>
References: <87oaunht4b.fsf@rustcorp.com.au> <20140911114351.GA25736@redhat.com> <87tx4dhbks.fsf@rustcorp.com.au> <20140914062116.GA23868@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 17 Sep 2014 01:23:46 +0930
Message-ID: <87a95zfto5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Fri, Sep 12, 2014 at 10:58:03AM +0930, Rusty Russell wrote:
>> "Michael S. Tsirkin" <mst@redhat.com> writes:
>> > On Thu, Sep 11, 2014 at 10:26:52AM +0930, Rusty Russell wrote:
>> >> Hi all,
>> >> 
>> >>         Probably won't read mail.  Linus, I'll have pull requests early
>> >> next week; if there's anything needed I'm sure Michael Tsirkin can
>> >> handle it.
>> >
>> > Sure.
>> > Rusty, there's a small chance virtio 1.0 bits will be ready in time.
>> > I started working on them based on your virtio-pci-new-layout branch.
>> >
>> > If ready before the merge window, are you ok with me merging this
>> > support (without you having the opportunity to review first)?
>> 
>> Sorry, absolutely not.  I *really* want to review this in depth; if we
>> make a mistake, it's going to hurt us significantly.
>
> Right but it's only a merge window - we can fix bugs and even disable
> the new driver afterwards, can't we?

Yes, but if we get something wrong we have to live with it.  We made
that mistake with virtio-pci the first time around...

It isn't enough that the code 'works', it has to match the spec.  And
that requires careful thought and review.

>> And until we have the qemu bits ready, it's really hard to tell if we've
>> got this right.
>
> Sure, I meant if qemu bits are ready too, and if things work together.
> It wouldn't do to merge a driver that isn't ready.
>
>
>>  So I'd rather delay and make sure we're solid.
>> 
>> Thanks,
>> Rusty.
>
> Something else we can do, is refactoring that splits driver
> out to common and legacy bits, and changes APIs.
> No?

Yes, for sure.  But there's no hurry to get those into the merge window.

Cheers,
Rusty.

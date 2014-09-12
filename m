Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaIMFGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 01:06:46 -0400
Received: from ozlabs.org ([103.22.144.67]:57803 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaIMFGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 01:06:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: Rusty away 18th September -- 11th October
In-Reply-To: <20140911114351.GA25736@redhat.com>
References: <87oaunht4b.fsf@rustcorp.com.au> <20140911114351.GA25736@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 12 Sep 2014 10:58:03 +0930
Message-ID: <87tx4dhbks.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Thu, Sep 11, 2014 at 10:26:52AM +0930, Rusty Russell wrote:
>> Hi all,
>> 
>>         Probably won't read mail.  Linus, I'll have pull requests early
>> next week; if there's anything needed I'm sure Michael Tsirkin can
>> handle it.
>
> Sure.
> Rusty, there's a small chance virtio 1.0 bits will be ready in time.
> I started working on them based on your virtio-pci-new-layout branch.
>
> If ready before the merge window, are you ok with me merging this
> support (without you having the opportunity to review first)?

Sorry, absolutely not.  I *really* want to review this in depth; if we
make a mistake, it's going to hurt us significantly.

And until we have the qemu bits ready, it's really hard to tell if we've
got this right.  So I'd rather delay and make sure we're solid.

Thanks,
Rusty.

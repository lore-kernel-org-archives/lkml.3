Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab3BOJn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 04:43:57 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:53463 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab3BOJnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 04:43:53 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130215102734.0ebe1b4826e94c83ed7a407d@canb.auug.org.au>
References: <CAKMK7uEQ7xQpsBay8SKjYM0oA0=uf3AePwZ+vEjukgOiLY9drg@mail.gmail.com>
	<20130214141953.GA5746@pd.tnic>
	<20130215102734.0ebe1b4826e94c83ed7a407d@canb.auug.org.au>
Date: Fri, 15 Feb 2013 10:43:52 +0100
Message-ID: <CAKMK7uGnvZUkrkf1MtTKgQFOYiKQVk7r-hCVLgW+Htp0MuJXWA@mail.gmail.com>
Subject: Re: Including drm-intel tree to linux-next
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Borislav Petkov <bp@alien8.de>, rostedt@goodmis.org,
        Dave Airlie <airlied@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 12:27 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Daniel,
>
> On Thu, 14 Feb 2013 15:19:53 +0100 Borislav Petkov <bp@alien8.de> wrote:
>>
>> On Thu, Feb 14, 2013 at 03:12:02PM +0100, Daniel Vetter wrote:
>> >
>> > Since about a year ago we've switched drm/i915 to buffer around 2
>> > weeks worth of patches so that we can do decent QA before breaking
>> > everyone's tree when things land in Dave's drm-next. But that also
>> > means we'll miss out a bit in the integration testing -next provides,
>> > which did hurt a bit in recent efforts. Hence can you please include
>> >
>> > git://people.freedesktop.org/~danvet/drm-intel drm-intel-next-queued
>> >
>> > into linux-next? Probably best to merge it after drm-next. Note that
>> > drm-intel-next are the QA'ed chunks I send off to Dave. Also, any
>> > mailing lists I'm supposed to follow? And if possible please cc
>> > intel-gfx@lists.freedesktop.org besides dri-devel/lkml when conflicts
>> > with that tree pop up (you won't get moderation spam any more, we've
>> > fixed that up).
>
> Added from today.  I am in two minds a bit since I really like stuff in
> linux-next to have been reviewed and debugged as much as possible.   But
> I have added it and will keep an eye on how many problems it causes.

The patches in my next queue are fully reviewed and (should) have seen
at least basic testing. The additional QA on top is just normal
regression testing and about every 2 weeks a manual testing cycle for
things like hotplug on the bazillion configurations we support (since
that takes our QA team about 1 week to complete we can't do higher
frequency there). The reason we've put that next queue buffer into
place was that before the pulls to Dave received essentially 0 testing
from our QA, resulting in lots more regressions slipping through.
-next-queued is also what I run here on all my machines and what patch
development is usually based on for drm/i915.

Does that put your concerns at ease?

> Problem reports will go to you, intel-gfx and dri-devel.  You can follow
> linux-next@vger.kernel.org (I sometimes post stuff there that goes
> nowhere else (except lkml - which noone seems to notice :-)).

Thanks, I'll subscribe to linux-next then.
-Daniel

>
> Thanks for adding your subsystem tree as a participant of linux-next.  As
> you may know, this is not a judgment of your code.  The purpose of
> linux-next is for integration testing and to lower the impact of
> conflicts between subsystems in the next merge window.
>
> You will need to ensure that the patches/commits in your tree/series have
> been:
>      * submitted under GPL v2 (or later) and include the Contributor's
>         Signed-off-by,
>      * posted to the relevant mailing list,
>      * reviewed by you (or another maintainer of your subsystem tree),
>      * successfully unit tested, and
>      * destined for the current or next Linux merge window.
>
> Basically, this should be just what you would send to Linus (or ask him
> to fetch).  It is allowed to be rebased if you deem it necessary.
>
> --
> Cheers,
> Stephen Rothwell
> sfr@canb.auug.org.au
>
> Legal Stuff:
> By participating in linux-next, your subsystem tree contributions are
> public and will be included in the linux-next trees.  You may be sent
> e-mail messages indicating errors or other issues when the
> patches/commits from your subsystem tree are merged and tested in
> linux-next.  These messages may also be cross-posted to the linux-next
> mailing list, the linux-kernel mailing list, etc.  The linux-next tree
> project and IBM (my employer) make no warranties regarding the linux-next
> project, the testing procedures, the results, the e-mails, etc.  If you
> don't agree to these ground rules, let me know and I'll remove your tree
> from participation in linux-next.



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

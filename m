Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab3HCWGQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 18:06:16 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:61560 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab3HCWGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 18:06:12 -0400
MIME-Version: 1.0
In-Reply-To: <2185529.xKyHXi1s1o@vostro.rjw.lan>
References: <2052880.bHfzt6NKt5@vostro.rjw.lan>
	<1963015.Y2AObmEn2f@vostro.rjw.lan>
	<CAMP44s2dbNBbKwLd9hGaYVPL_Z6-v_S0xZpmz8cwicg1wgMr+Q@mail.gmail.com>
	<2185529.xKyHXi1s1o@vostro.rjw.lan>
Date: Sat, 3 Aug 2013 17:06:10 -0500
Message-ID: <CAMP44s3LC2XzDrQmJ9iPuT04=WnxZcNj7grx9pE=NTxqG=kSvQ@mail.gmail.com>
Subject: Re: [GIT PULL] ACPI and power management fixes for v3.11-rc4
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 3, 2013 at 4:59 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, August 03, 2013 03:20:22 PM Felipe Contreras wrote:
>> On Sat, Aug 3, 2013 at 6:54 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Friday, August 02, 2013 08:48:09 PM Felipe Contreras wrote:
>>
>> >> Yes, that's fine, either the revert, or the patch I mentioned, or
>> >> something else, but something has to be done, and it was better to do
>> >> it in v3.11-rc4 than in v3.11-rc5, because that change itself can
>> >> cause further problems.
>> >
>> > A revert can be done in -rc5 just fine.  If we don't have a working fix this
>> > week, I'll do the revert.
>>
>> I think you are waiting for miracles. But whatever.
>>
>> >> Let's do a though experiment, let's say you are right, and they can
>> >> survive the 6 months it would take you to find the "perfect" solution,
>> >> say in v3.13. What's wrong with having a partial solution in v3.12? If
>> >> the blacklisting doesn't work properly (there's absolutely no evidence
>> >> for that), then you revert it on v3.12.1.
>> >>
>> >> What's wrong with that approach?
>> >
>> > If the blacklisting leads to problems, they may not be reported in the 3.12
>> > time frame, but much later.  For example because people won't realize that
>> > the problems are caused by the blacklisting until much much later.  And then
>> > we'll be in a spot where whatever we do will break things for someone.
>>
>> The key word is *may*, you don't *know*. Why do you insist in
>> committing this reification fallacy?
>>
>> This threat is not real, it's theoretical.
>
> I believe it is real.

That is called wishful thinking. Believing so doesn't make it so.

> Igor has told you that already, hasn't he?

He said he "had problems", that doesn't mean much. What kind of
problems? Did he have those problems in v3.10? Does v3.11-rc3 work
correctly? Did he boot without any boot arguments?

"I had problems" is almost meaningless.

>> But let's suppose you are right, and there are issues, and those don't
>> get reported in v3.12. That is actually GOOD, if people don't report
>> issues, it means the issues are not that big, or not even *there*.
>
> You don't even realize how wrong you are.  The issues that aren't visible
> in testing from the start are often much *worse* than those we can see
> immediately, because usually they are much more difficult to fix and they
> cause much more pain overall as a result.

How convenient. In other words; there's absolutely no empirical way to
prove you wrong.

It's like trying to prove that your invisible pink unicorn doesn't exist.

If we don't find evidence of problems, that is evidence that there are
no problems. And even if there are "invisible" "worse" issues, it
doesn't matter, because you will fix them properly in six months,
right?

I'd say, fix the visible (aka. real) issues, don't worry about the
invisible (aka. imaginary) ones. Worry when they are visible.

>> And no, we won't be in a spot where whatever we do will break things,
>> because if the intel backlight driver works correctly, that solution
>> would work for everyone. And if it doesn't, we should stay with what
>> works best.
>>
>> > And we had situations like that in the past, which is the source of my concern.
>> > You obviously don't have that experience, or you won't be so eager to inflict
>> > the blacklisting on everyone.
>> >
>> > Anyway, as you know, but conveniently don't mention, I asked some experienced
>> > people for opinions about that.  If they agree with you, we will add the
>> > blacklist.  If they don't, we won't add it.
>>
>> Again, screw the users. We are stuck with broken backlight for several
>> more months to come. Great.
>
> Whatever you are thinking you will achieve this way, it doesn't work.

It is the reality: v3.7 is broken, v3.8 is broken, v3.9 is broken,
v3.10 is broken, v3.11 is going to be broken, v3.12 will probably be
broken too, and perhaps even v3.13.

Who benefits from this?

-- 
Felipe Contreras

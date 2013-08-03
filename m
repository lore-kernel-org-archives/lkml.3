Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab3HCUU0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 16:20:26 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:34873 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab3HCUUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 16:20:24 -0400
MIME-Version: 1.0
In-Reply-To: <1963015.Y2AObmEn2f@vostro.rjw.lan>
References: <2052880.bHfzt6NKt5@vostro.rjw.lan>
	<6100577.WGRZRabKGy@vostro.rjw.lan>
	<CAMP44s1Knox3oVt3-ePkDHxa2uNQAFVFRwmVTATNknWA46b_Uw@mail.gmail.com>
	<1963015.Y2AObmEn2f@vostro.rjw.lan>
Date: Sat, 3 Aug 2013 15:20:22 -0500
Message-ID: <CAMP44s2dbNBbKwLd9hGaYVPL_Z6-v_S0xZpmz8cwicg1wgMr+Q@mail.gmail.com>
Subject: Re: [GIT PULL] ACPI and power management fixes for v3.11-rc4
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 3, 2013 at 6:54 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, August 02, 2013 08:48:09 PM Felipe Contreras wrote:

>> Yes, that's fine, either the revert, or the patch I mentioned, or
>> something else, but something has to be done, and it was better to do
>> it in v3.11-rc4 than in v3.11-rc5, because that change itself can
>> cause further problems.
>
> A revert can be done in -rc5 just fine.  If we don't have a working fix this
> week, I'll do the revert.

I think you are waiting for miracles. But whatever.

>> Let's do a though experiment, let's say you are right, and they can
>> survive the 6 months it would take you to find the "perfect" solution,
>> say in v3.13. What's wrong with having a partial solution in v3.12? If
>> the blacklisting doesn't work properly (there's absolutely no evidence
>> for that), then you revert it on v3.12.1.
>>
>> What's wrong with that approach?
>
> If the blacklisting leads to problems, they may not be reported in the 3.12
> time frame, but much later.  For example because people won't realize that
> the problems are caused by the blacklisting until much much later.  And then
> we'll be in a spot where whatever we do will break things for someone.

The key word is *may*, you don't *know*. Why do you insist in
committing this reification fallacy?

This threat is not real, it's theoretical.

But let's suppose you are right, and there are issues, and those don't
get reported in v3.12. That is actually GOOD, if people don't report
issues, it means the issues are not that big, or not even *there*.

And no, we won't be in a spot where whatever we do will break things,
because if the intel backlight driver works correctly, that solution
would work for everyone. And if it doesn't, we should stay with what
works best.

> And we had situations like that in the past, which is the source of my concern.
> You obviously don't have that experience, or you won't be so eager to inflict
> the blacklisting on everyone.
>
> Anyway, as you know, but conveniently don't mention, I asked some experienced
> people for opinions about that.  If they agree with you, we will add the
> blacklist.  If they don't, we won't add it.

Again, screw the users. We are stuck with broken backlight for several
more months to come. Great.

-- 
Felipe Contreras

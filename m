Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbbA0Xyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:54:43 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:51237 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbbA0Xyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:54:41 -0500
MIME-Version: 1.0
In-Reply-To: <20150121061642.GD15963@gmail.com>
References: <20150119170839.2c6b4b78@canb.auug.org.au> <20150119093501.GA4644@pd.tnic>
 <CALCETrW05f9nty5Sk8XA2DTsocqqOxp62aT9QXwta74Km+ZOng@mail.gmail.com>
 <20150121053410.GA15291@gmail.com> <CALCETrXCenu4UexZfV6HTq898JbXmZGU5KaCWCXrz7oikrA34g@mail.gmail.com>
 <20150121055532.GA15518@gmail.com> <CALCETrVKEZz+NFiqxrgQhqhDZ6dPLSr32RiBoZZmFk5ZydEL1w@mail.gmail.com>
 <20150121061642.GD15963@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 27 Jan 2015 15:54:19 -0800
Message-ID: <CALCETrWBELO_ou7PH0axx7c9qmrWoJRdZdzCRL0__6TBYaJbaQ@mail.gmail.com>
Subject: Re: Fwd: linux-next: manual merge of the luto-misc tree with the tip tree
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 10:16 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Andy Lutomirski <luto@amacapital.net> wrote:
>
>> On Tue, Jan 20, 2015 at 9:55 PM, Ingo Molnar <mingo@kernel.org> wrote:
>> >
>> > * Andy Lutomirski <luto@amacapital.net> wrote:
>> >
>> >> On Tue, Jan 20, 2015 at 9:34 PM, Ingo Molnar <mingo@kernel.org> wrote:
>> >> >
>> >> > * Andy Lutomirski <luto@amacapital.net> wrote:
>> >> >
>> >> >> Hi Ingo and Thomas-
>> >> >>
>> >> >> There's a trivial conflict in the pull request I sent last week.
>> >> >
>> >> > This is your x86 entry code rework pull request, right? The -tip
>> >> > tree now has the RCU commit it depends on, so could you please
>> >> > rebase it on top of tip:core/rcu so I can pull it? I'll resolve
>> >> > any remaining conflicts with the rest of -tip.
>> >> >
>> >>
>> >> Sure, I can do that in the morning.  The pull request merges cleanly
>> >> with tip:core/rcu, though, so is the rebase needed?
>> >
>> > Yes, because your changes rely on the RCU change (semantically),
>> > so if anyone bisects into your commits it might result in a
>> > subtly broken kernel, right?
>>
>> Almost.  The parent of my original pull request is the RCU
>> change that my entry changes semantically depend on, so
>> bisection should be fine.
>
> Okay, that's good - so now I can pull your bits, because the RCU
> commit is final, no need to rebase. (Because you already based
> your bits on the RCU change that later on ended up in -tip.)
>

Are you planning on pulling that version?  In the mean time, I removed
it from -next so that there won't be a pointless conflict depending on
which version you pull.

Thanks,
Andy

> Thanks,
>
>         Ingo



-- 
Andy Lutomirski
AMA Capital Management, LLC

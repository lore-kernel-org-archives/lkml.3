Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab3KDTxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 14:53:16 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:60391 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab3KDTxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 14:53:15 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA47mQcKf0D5vNpQrt-9cQWMUMPRS0kZybmJzrnwdNPC-Q@mail.gmail.com>
References: <CA+55aFwLkvSkparyvekdmMyvr6Srw1KkzTBp=_w0oQRWnPpJug@mail.gmail.com>
	<20131104062540.GA12149@gmail.com>
	<CA+5PVA47mQcKf0D5vNpQrt-9cQWMUMPRS0kZybmJzrnwdNPC-Q@mail.gmail.com>
Date: Mon, 4 Nov 2013 20:53:15 +0100
X-Google-Sender-Auth: 3M_l3QqRHOS6sZ3EY0WAqKingTQ
Message-ID: <CAMuHMdU42shGH8WurDr6BkOwW0KNh-rF2EjgjepDozLr_=VDEA@mail.gmail.com>
Subject: Re: Linux 3.12 released .. and no merge window yet .. and 4.0 plans?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 4, 2013 at 8:08 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>>> So I may be pessimistic, but I'd expect many developers would go "Let's
>>> hunt bugs.. Wait. Oooh, shiny" and go off doing some new feature after
>>> all instead. Or just take that release off.
>>>
>>> But I do wonder.. Maybe it would be possible, and I'm just unfairly
>>> projecting my own inner squirrel onto other kernel developers. If we
>>> have enough heads-up that people *know* that for one release (and
>>> companies/managers know that too) the only patches that get accepted are
>>> the kind that fix bugs, maybe people really would have sufficient
>>> attention span that it could work.
>>>
>>> And the reason I mention "4.0" is that it would be a lovely time to do
>>> that. Roughly a years heads-up that "ok, after 3.19 (or whatever), we're
>>> doing a release with *just* fixes, and then that becomes 4.0".
>>>
>>> Comments?
>>
>> I think the biggest problem wouldn't even be the enforcement of
>> bugfixes-only during that 2.5 months period, or kernel developers
>> surviving such a long streak of boredom, but v3.19 would also probably be
>> a super-stressful release to maintainers, as everyone would try to cram
>> their feature in there. And if anything important misses that window then
>> it's a +5 months wait...
>
> I'd agree with that, but it wouldn't be limited to just the final
> non-bugfix release.  It would be a year-long "shove as much as we can
> in" push, and I'd be fearful of doing any distro kernel based on any
> one of those releases.  Clearly the subsystem maintainers would still
> be fighting the good fight, but I'm concerned they'd be overwhelmed
> and/or burnt out by the time 4.0 came around.

I'm afraid to avoid that, you have to do the bug-fixing release *now*,
without early warning...

Yes, it screws all short-term planning, but it relieves the stress from all
maintainters, and puts the stress/blame on a single person, of which we
all know he can handle it and say "no".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

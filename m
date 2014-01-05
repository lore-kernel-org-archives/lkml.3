Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbaAEOcj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 09:32:39 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:65194 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaAEOci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 09:32:38 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXU3TGfLec3H6JqLv4yrUVzHN-POMRMBEJvi9-KvBu1mw@mail.gmail.com>
References: <CAPNrq4yXdbdfq4hrtZdZn_5UDPduGoTCNJb1-9u-Qf1nf2RgXQ@mail.gmail.com>
 <20140104213654.0f0b34f2@neptune.home> <CAMuHMdXU3TGfLec3H6JqLv4yrUVzHN-POMRMBEJvi9-KvBu1mw@mail.gmail.com>
From: "Gideon D'souza" <gidisrael@gmail.com>
Date: Sun, 5 Jan 2014 20:02:17 +0530
Message-ID: <CAPNrq4xKgwZjGHNJYnDVKtHRAusOpzFzk1ML-gmuNOSUovD66g@mail.gmail.com>
Subject: Re: How does a newbie find work?
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks so much Geert and Bruno for your replies:


>>don't forget to subscribe to the specific mailing lists!
Didn't know about this, this link is the right one?
http://vger.kernel.org/vger-lists.html#cpufreq There isn't a list for
the scheduler though?

>A better start, and at least as useful is to read and review patches flowing
> by that affect your areas of interest, test them and
> provide feedback about possible bugs or improvements
This is a really good idea, so far though all the patches to me look a
little arcane, for things I barely understand. But I will keep
looking. If I do find something, lets say a patch to the scheduler or
some networking thing, how do you guys really test this out? How to
you debug a scheduler? :/ How do I really "See" the system run? Put
printk statements here are there?


>E.g. one thing I just noticed: while include/linux/compiler-gcc.h provides
>shorthands (e.g. "__printf()") for various gcc __attribute__ macros, there
>are still many places that don't use the shorthands, cfr. e.g.
>"git grep 'attribute.*printf'".
Are trivial patches like this really accepted?

Regards,
Gideon

On Sun, Jan 5, 2014 at 3:02 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Sat, Jan 4, 2014 at 9:36 PM, Bruno Prémont <bonbons@linux-vserver.org> wrote:
>>> Is there some simple work a newbie like me can take up? Any maintainer
>>> need some grunt work done? Or perhaps someone could suggest a pet
>>> project I could try to understand things better? (Should I be learning
>>> how to write device drivers?)
>>>
>>> Things that are very interesting to me so far are the KVM and the Scheduler.
>>
>> Starting with writing some driver (or improving existing drivers) is one
>> option, though that wont get you doing work in relation with the scheduler
>> (maybe there is some minor driver-like work for KVM though, don't know).
>>
>> A better start, and at least as useful is to read and review patches
>> flowing by that affect your areas of interest, test them and provide
>> feedback about possible bugs or improvements (proposing patches to fix
>> those if applicable or even just providing performance data [what
>> workloads benefit or suffer from given feature-patches and by how much]
>> for things like scheduler changes).
>>
>> This way you will get to know the development process, maintainers
>> and the internals of the kernel in those areas - don't forget to subscribe
>> to the specific mailing lists!
>
> Yep, all very good advices. And while following the above, you will hopefully
> notice things that need bug fixes, cleanups, or other work.
>
> E.g. one thing I just noticed: while include/linux/compiler-gcc.h provides
> shorthands (e.g. "__printf()") for various gcc __attribute__ macros, there
> are still many places that don't use the shorthands, cfr. e.g.
> "git grep 'attribute.*printf'".
>
> As some of these are in architecture-specific header files, and need build
> testing there, this is an opportunity to get some cross-compilers going (you
> can download binaries from https://www.kernel.org/pub/tools/crosstool/) as
> well.
>
> Good luck, thanks, and welcome to the team! ;-)
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds

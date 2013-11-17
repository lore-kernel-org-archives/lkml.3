Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab3KQPUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 10:20:00 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:61182 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab3KQPTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 10:19:54 -0500
MIME-Version: 1.0
In-Reply-To: <20131117092731.75b091bd@gandalf.local.home>
References: <20131115093645.6dc03918@gandalf.local.home>
	<CAMuHMdXSBSOkfd2MGbn=rpXQRZYw5TKLsR=3SoeSyrcD2CzunA@mail.gmail.com>
	<20131117092731.75b091bd@gandalf.local.home>
Date: Sun, 17 Nov 2013 16:19:53 +0100
X-Google-Sender-Auth: L4YXeup2ayr2IQBwoVHvoGBYMKU
Message-ID: <CAMuHMdWNh2L56FhDbKfC7TtdHp8=EY2ms_T+=9Xyczz3D-PF=w@mail.gmail.com>
Subject: Re: [PATCH] scripts: Have make TAGS not include structure members
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Yang Bai <hamo.by@gmail.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 3:27 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> On Fri, Nov 15, 2013 at 3:36 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > It is really annoying when I use emacs TAGS to search for something
>> > like "dev_name" and have to go through 12 iterations before I find the
>> > function "dev_name". I really do not care about structures that include
>> > "dev_name" as one of its fields, and I'm sure pretty much all other
>> > developers do not care either.
>>
>> While I'm also annoyed by this (although with vim/tags), I regularly do search
>> for struct members, so losing this ability would hurt, too.
>>
>> Is there a solution, without throwing out the baby with the bath water?
>>
>
> Or perhaps make it only do it for TAGS. vim gives you a list of
> locations that you can go to, and even marks if it is a member of a
> structure or a function or whatever. With emacs, you have to iterate
> over each location. That is, with my devname example, I had to hit M^.
> then Ctrl^U M^. another 12 times before I got to the function name.
> It makes it absolutely worthless, that after two or three misses, I
> give up and just grep for it.

Thanks! Now I have to look into my vim setup, why it doesn't do the
above...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

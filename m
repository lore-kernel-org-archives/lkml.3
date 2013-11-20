Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab3KTI3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 03:29:52 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:57261 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3KTI3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 03:29:50 -0500
MIME-Version: 1.0
In-Reply-To: <20131117120816.41fe2528@gandalf.local.home>
References: <20131115093645.6dc03918@gandalf.local.home>
	<CAMuHMdXSBSOkfd2MGbn=rpXQRZYw5TKLsR=3SoeSyrcD2CzunA@mail.gmail.com>
	<20131117092731.75b091bd@gandalf.local.home>
	<CAMuHMdWNh2L56FhDbKfC7TtdHp8=EY2ms_T+=9Xyczz3D-PF=w@mail.gmail.com>
	<20131117120816.41fe2528@gandalf.local.home>
Date: Wed, 20 Nov 2013 09:29:50 +0100
X-Google-Sender-Auth: eVmAYUlQAuVXUFO9pFMQEoIOhvQ
Message-ID: <CAMuHMdWLqC1ihx_AifUpF166tpuv0fLwj34trm65BzLw_-kRKA@mail.gmail.com>
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

On Sun, Nov 17, 2013 at 6:08 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sun, 17 Nov 2013 16:19:53 +0100
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
>> Thanks! Now I have to look into my vim setup, why it doesn't do the
>> above...
>
> $ vim --version
> VIM - Vi IMproved 7.4 (2013 Aug 10, compiled Sep 11 2013 12:28:07)

I have 7.3.

> And from the ctags man pages, I did:
>
> :ta dev_name
>
> and it gave me a list of tags.

Not for me.

>   # pri kind tag               file
>   1 F   m    dev_name          drivers/clk/samsung/clk.h
>                struct:samsung_clock_alias
>                const char  *dev_name;

I do remember seeing such a list on a different machine, though.

However,  this encouraged me to dive into some docs.
":ts <tag>" (or just ":ts" after a previous ":ta") does give me the list.
 The same for "g CTRL-]" instead of plain "CTRL-]", so I'm happy now ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

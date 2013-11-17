Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab3KQJPB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 04:15:01 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33522 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab3KQJOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 04:14:47 -0500
MIME-Version: 1.0
In-Reply-To: <20131115093645.6dc03918@gandalf.local.home>
References: <20131115093645.6dc03918@gandalf.local.home>
Date: Sun, 17 Nov 2013 10:14:46 +0100
X-Google-Sender-Auth: rjtHxtELPvJEYkVuTMx5qKNaF3g
Message-ID: <CAMuHMdXSBSOkfd2MGbn=rpXQRZYw5TKLsR=3SoeSyrcD2CzunA@mail.gmail.com>
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

On Fri, Nov 15, 2013 at 3:36 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> It is really annoying when I use emacs TAGS to search for something
> like "dev_name" and have to go through 12 iterations before I find the
> function "dev_name". I really do not care about structures that include
> "dev_name" as one of its fields, and I'm sure pretty much all other
> developers do not care either.

While I'm also annoyed by this (although with vim/tags), I regularly do search
for struct members, so losing this ability would hurt, too.

Is there a solution, without throwing out the baby with the bath water?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

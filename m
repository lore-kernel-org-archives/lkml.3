Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaCXMVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 08:21:11 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:43176 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbaCXMVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 08:21:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140323193745.GA10482@redhat.com>
References: <20140323193730.GA10464@redhat.com>
	<20140323193745.GA10482@redhat.com>
Date: Mon, 24 Mar 2014 13:21:06 +0100
X-Google-Sender-Auth: 74lyuUbGZ_bI4B262-gN-xOZlHw
Message-ID: <CAMuHMdUcDpKbo9r4MJA+FGeBq4WT_V_TW2wG+yQvHqbGxvaqBA@mail.gmail.com>
Subject: Re: [PATCH 01/11] signals: kill sigfindinword()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Sun, Mar 23, 2014 at 8:37 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> It has no users and it doesn't look useful. I do not know why/when it
> was introduced, I can't even find any user in the git history.

2.1.68pre1 for i386, 2.1.87pre1 for m68k (which used to follow i386 very
closely ;-), but never used in mainline code.

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thank!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

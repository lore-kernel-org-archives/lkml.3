Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab3EGMNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:13:23 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47130 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab3EGMNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:13:21 -0400
MIME-Version: 1.0
In-Reply-To: <20130507120201.GP25399@ZenIV.linux.org.uk>
References: <1367920320-18382-1-git-send-email-geert@linux-m68k.org>
	<20130507120201.GP25399@ZenIV.linux.org.uk>
Date: Tue, 7 May 2013 14:13:21 +0200
X-Google-Sender-Auth: MGomvFm1OrZeK-azpyv21rLKFgQ
Message-ID: <CAMuHMdUnWwN-Fg9RH+PuYZMoZ47eN7f8AuUsdP9FJXP3AutA8g@mail.gmail.com>
Subject: Re: [PATCH] h8300: Hardcode symbol prefixes in asm sources
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 2:02 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, May 07, 2013 at 11:52:00AM +0200, Geert Uytterhoeven wrote:
>>  arch/h8300/kernel/syscalls.S                     |  646 +++++++++++-----------
>
> NAK on this part - either turn it into array initialized in something.c,
> or at least do something like
> #define CALL(x) .long _##x
> and use that to fill the damn thing.

That's something different. This patch is about fixing a regression.

Converting it to the new syscall table generation hype/framework is less urgent.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

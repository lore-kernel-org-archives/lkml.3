Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab3HRUjG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:39:06 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:61022 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab3HRUjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:39:02 -0400
MIME-Version: 1.0
In-Reply-To: <20130818203623.850246787@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
	<20130818203623.850246787@linuxfoundation.org>
Date: Sun, 18 Aug 2013 22:39:01 +0200
X-Google-Sender-Auth: e6nSXjOYjoM-iXghAUPGISnk0Io
Message-ID: <CAMuHMdWP2f_9526y9g5n=vf_Nga5XyC36JZhi7f5mMqMV4mW+w@mail.gmail.com>
Subject: Re: [ 41/45] m68k: Truncate base in do_div()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 10:36 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> 3.10-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Andreas Schwab <schwab@linux-m68k.org>
>
> commit ea077b1b96e073eac5c3c5590529e964767fc5f7 upstream.
>
> Explicitly truncate the second operand of do_div() to 32 bits to guard
> against bogus code calling it with a 64-bit divisor.
>
> [Thorsten]
>
> After upgrading from 3.2 to 3.10, mounting a btrfs volume fails with:
>
> btrfs: setting nodatacow, compression disabled
> btrfs: enabling auto recovery
> btrfs: disk space caching is enabled

What happened to the rest of the commit message?

> ---
>  arch/m68k/include/asm/div64.h |    9 +++++----

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

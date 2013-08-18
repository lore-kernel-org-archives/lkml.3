Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab3HRUhH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:37:07 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:54927 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab3HRUhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:37:02 -0400
MIME-Version: 1.0
In-Reply-To: <20130818202949.875887601@linuxfoundation.org>
References: <20130818202949.875887601@linuxfoundation.org>
Date: Sun, 18 Aug 2013 22:37:01 +0200
X-Google-Sender-Auth: kE4tO0pm6edUFZ3tk7TFWuf557I
Message-ID: <CAMuHMdUjM8oQLcbLJ+Zkh8=5Hy=vnY6ogwFRANxSGAxCjxVd2A@mail.gmail.com>
Subject: Re: [ 00/12] 3.0.92-stable review
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Sun, Aug 18, 2013 at 10:30 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 3.0.92 release.

Please also include

commit ea077b1b96e073eac5c3c5590529e964767fc5f7
Author: Andreas Schwab <schwab@linux-m68k.org>
Date:   Fri Aug 9 15:14:08 2013 +0200

    m68k: Truncate base in do_div()

While the crash mentioned in that commit doesn't happen in 3.2 and earlier,
there are a few other places in the kernel that call do_div() with a
64-bit divisor,
causing unexpected behavior.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

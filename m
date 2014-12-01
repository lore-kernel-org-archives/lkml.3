Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632AbaLAVfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:35:44 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61003 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421AbaLAVfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:35:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAMo8BfKg=eb7wA2O+cKO+oLDDERh2CKBS7dyAvfqvCESEHWYEg@mail.gmail.com>
References: <547CD304.20407@gmail.com>
	<CAMo8BfKg=eb7wA2O+cKO+oLDDERh2CKBS7dyAvfqvCESEHWYEg@mail.gmail.com>
Date: Mon, 1 Dec 2014 22:35:40 +0100
X-Google-Sender-Auth: 6VXdUw5xZXDfZMZhVlK_VZQ8NFY
Message-ID: <CAMuHMdXHAZFujShNnAHY8BRv85ncrtcRvRgPS0Br0T9gSxZ+1A@mail.gmail.com>
Subject: Re: [PATCH] arch: uapi: asm: mman.h: Support MADV_FREE for madvise()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>, Minchan Kim <minchan@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "ink@jurassic.park.msu.ru" <ink@jurassic.park.msu.ru>,
        "mattst88@gmail.com" <mattst88@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "jejb@parisc-linux.org" <jejb@parisc-linux.org>,
        "deller@gmx.de" <deller@gmx.de>, "chris@zankel.net" <chris@zankel.net>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 9:52 PM, Max Filippov <jcmvbkbc@gmail.com> wrote:
> On Mon, Dec 1, 2014 at 11:43 PM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
>> At present, kernel supports madvise(MADV_FREE), so can benefit to all
>> related architectures (can grep MADV_WILLNEED or MADV_REMOVE in "arch/"
>> to know about all related architectures).
>
> A similar patch has been posted a while ago:
>
> http://www.spinics.net/lists/linux-mm/msg81538.html

Would it be possible to use the same number everywhere?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

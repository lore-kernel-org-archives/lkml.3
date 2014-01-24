Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaAXGDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 01:03:06 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:57681 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaAXGC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 01:02:58 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1401231552260.23605@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401231259340.31739@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401231302340.31739@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401231303100.31739@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401231303460.31739@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMuHMdWebQNKh4G8ZjpmZV15riHFpLiz5j1V4H+iSZ3VQp91gA@mail.gmail.com>
	<alpine.LRH.2.02.1401231552260.23605@file01.intranet.prod.int.rdu2.redhat.com>
Date: Fri, 24 Jan 2014 07:02:57 +0100
X-Google-Sender-Auth: r1rjsqpXApEGKUrderjhxIeLn-I
Message-ID: <CAMuHMdV_4a9zvht0V4-C+RvTM=GVJneZzdz1Lkiw-9ixmzcZYQ@mail.gmail.com>
Subject: Re: [PATCH 3/10] framebuffer: fix cfb_copyarea
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 9:55 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>> BTW, good to see you still have a working TGA. My PPC and Alpha gear
>> died a decade ago.
>
> With the patches that I sent, I can switch it to 1920x1080 and let it
> drive my monitor in native resolution. I was wondering how such an old
> card can do that :)

Don't underestimate the TGA.

Furthermore, 1920x1080 TFT only needs a 148 MHz dot clock.
CRTs needed higher dot clocks (at lower resolutions) to avoid flicker.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

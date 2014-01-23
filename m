Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbaAWU1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 15:27:16 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:54607 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaAWU1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 15:27:14 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1401231303460.31739@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401231259340.31739@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401231302340.31739@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401231303100.31739@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401231303460.31739@file01.intranet.prod.int.rdu2.redhat.com>
Date: Thu, 23 Jan 2014 21:27:14 +0100
X-Google-Sender-Auth: UUI1iNCcdIVoF3Nz4iU3kE5XEus
Message-ID: <CAMuHMdWebQNKh4G8ZjpmZV15riHFpLiz5j1V4H+iSZ3VQp91gA@mail.gmail.com>
Subject: Re: [PATCH 3/10] framebuffer: fix cfb_copyarea
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 7:18 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> The cfb_copyarea code was very buggy and it looks like it was written
> and never tried with non-8-pixel font.

My memory may suffer from bitrot, but I think I tested it with the Sun
12x22 font. That was on big endian (PPC), though.

BTW, good to see you still have a working TGA. My PPC and Alpha gear
died a decade ago.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

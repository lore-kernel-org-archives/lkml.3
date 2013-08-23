Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab3HWLjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:39:09 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:60849 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab3HWLjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:39:07 -0400
MIME-Version: 1.0
In-Reply-To: <1376929831-18214-1-git-send-email-richard.genoud@gmail.com>
References: <1376929831-18214-1-git-send-email-richard.genoud@gmail.com>
Date: Fri, 23 Aug 2013 13:39:06 +0200
X-Google-Sender-Auth: eBZ1b3zBvkRvQq1myW-fmXxN3vI
Message-ID: <CAMuHMdXwSbT781Bn_oX=6-RjHeUsfpraNS1z=8Ed=KVswZKO=g@mail.gmail.com>
Subject: Re: [PATCH] proc: return on proc_readdir error
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 6:30 PM, Richard Genoud
<richard.genoud@gmail.com> wrote:
> This is not triggered on glibc (as getdents is called with a 32KB
> buffer), but on uclibc, the buffer size is only 1KB, thus some proc
> entries are missing.

JFYI, on glibc 2.3.6.ds1-13 it's also 1 KiB.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

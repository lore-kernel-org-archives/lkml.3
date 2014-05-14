Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbaENJ6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:58:34 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:35126 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbaENJ6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:58:32 -0400
MIME-Version: 1.0
In-Reply-To: <5372C86E.5020708@lougher.demon.co.uk>
References: <5372C86E.5020708@lougher.demon.co.uk>
Date: Wed, 14 May 2014 11:58:32 +0200
X-Google-Sender-Auth: RPyqDLfWtnX_mCDW1hQnRAkBko8
Message-ID: <CAMuHMdUwnJsHEAxop4XPM1Qy1+tnv+6q3RSgLBHqdN-F2sdB7w@mail.gmail.com>
Subject: Re: [ANN] Squashfs tools 4.3 released
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Phillip,

On Wed, May 14, 2014 at 3:35 AM, Phillip Lougher
<phillip@lougher.demon.co.uk> wrote:
> I'm pleased to announce the release of Squashfs tools 4.3.

Thanks a lot!

> 8. The file being compressed/uncompressed in Mksquashfs/Unsquashfs is now
>    displayed if CTRL-\ (SIGQUIT from keyboard) typed.
>
> 9. The status of the internal queues/caches in Mksquashfs/Unsquashfs is
>    now displayed if CTRL-\ (SIGQUIT from keyboard) is typed twice within
>    one second.  Normally only useful for "power users", but it can be
>    used to discover if there's any bottlenecks affecting performance
>    (the bottleneck will normally be the compressors/fragment compressors).

Sorry for being a bit later, but I'm wondering if it would be better to use
SIGUSR1 (cfr. dd(1)), instead of modifying the behavior for a standard
signal like SIGQUIT?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab3G2Ep5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 00:45:57 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:57420 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3G2Ep4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 00:45:56 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxb3NT3_04ZLKiCFrtTXSdi4bfQFf0HJviRRYPTW4ymXA@mail.gmail.com>
References: <CA+55aFxb3NT3_04ZLKiCFrtTXSdi4bfQFf0HJviRRYPTW4ymXA@mail.gmail.com>
Date: Sun, 28 Jul 2013 21:45:55 -0700
X-Google-Sender-Auth: S4dNbPQxc8y0karcdyfxrIFh9dw
Message-ID: <CA+55aFzHSCbQ2x+w6NVTKekW5botr1yByt0Cp7Zm3Bk-nSxC9Q@mail.gmail.com>
Subject: Re: Linux 3.11-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 28, 2013 at 9:42 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Full shortlog since rc2 appended. It's big enough that I debated doing
> just a merge-window style "mergelog" overview, but hey, maybe people
> enjoy this kind of detail?

Just for comparison, here's the "mergelog" that just talks about the
things I merged and the people I pulled from, rather than the shortlog
of every commit. Maybe that gives a better "overview" picture of what
happened. You tell me..

               Linus

---

   Ben Herrenschmidt: (1)
       powerpc fixes

   Ben Myers: (1)
       xfs fix

   Bruce Fields: (1)
       nfsd fix

   Catalin Marinas: (1)
       arm64 fixes

   Dave Airlie: (3)
       drm fixes
       qxl drm fixes
       drm fixes

   Grant Likely: (1)
       device tree bug fixes and maintainership updates

   Greg KH: (4)
       USB fixes
       tty/serial fixes
       staging fixes
       char/misc patches

   Herbert Xu: (1)
       crypto fixes

   James Bottomley: (1)
       SCSI fixes

   Jens Axboe: (1)
       block IO driver bits

   Linus Walleij: (2)
       pin control fixes
       gpio fixes

   Matt Turner: (1)
       alpha architecture fixes

   Michael Tsirkin: (1)
       vhost fixes

   Miklos Szeredi: (1)
       fuse bugfixes

   Neil Brown: (1)
       md fixes

   Olof Johansson: (1)
       ARM SoC fixes

   Rafael Wysocki: (1)
       ACPI and power management fixes

   Steven Rostedt: (2)
       tracing fixes
       tracing fixes and cleanups

   Takashi Iwai: (1)
       sound fixes

   Tejun Heo: (2)
       libata fixes
       cgroup changes

   Tony Luck: (1)
       EDAC fix

   Zhang Rui: (1)
       thermal management fixes

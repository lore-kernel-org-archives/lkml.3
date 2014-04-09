Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934080AbaDIQlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:41:04 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:58977 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100AbaDIQk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:40:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140408134740.GB28822@thunk.org>
References: <20140403191558.GA8745@thunk.org>
	<CA+55aFxoA-iDdmbbgmJiYVvskrtca5aGgUAW=3CR47rM9NEMLA@mail.gmail.com>
	<20140404035308.GC2525@thunk.org>
	<20140404134429.GB26806@quack.suse.cz>
	<CAJfpegsJd9d8NTmwozJ+u_ZS-SnUwAQFwAne6P1KqG=VZeZSTA@mail.gmail.com>
	<20140404234358.GE10275@thunk.org>
	<CAJfpegv_Ng1cXbpCqicG4e3UdGK3uiDtVB4KzfRQOhDq_uhZOw@mail.gmail.com>
	<20140407140745.GA8855@thunk.org>
	<CAMuHMdVHyAJwJv5nh+nQUOQJk6=2+Rr+pEqAZPgJUsA7A9A3hQ@mail.gmail.com>
	<20140408134740.GB28822@thunk.org>
Date: Wed, 9 Apr 2014 18:40:57 +0200
X-Google-Sender-Auth: MxqYsBS2zlCIRtwQrqCbujUemec
Message-ID: <CAMuHMdW8xkBFJ5-E04rVhDk+CSubHut+kx3P6cYCn0dMhQdb-Q@mail.gmail.com>
Subject: Re: [GIT PULL] ext4 changes for 3.15
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 3:47 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Apr 07, 2014 at 10:25:30PM +0200, Geert Uytterhoeven wrote:
>> > maintainers would have no idea that a new syscall has been added.
>>
>> If i386 has the new syscall, scripts/checksyscalls.sh will catch it and
>> inform us about it during our next kernel build.
>>
>> If you add it to x86_64 only, bad luck for anyone else ;-)
>
> Maybe we should change scripts/checksyscalls.sh to check the x86_64
> list of syscalls, and not i386?
>
> It's been a long time since "all the world's an i386" --- these days,
> it's "all the world's an x86_64".  :-)

Let the kbuild people (and their employers) fight over it...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

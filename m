Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934298AbaDITV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:21:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49449 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933143AbaDITV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:21:56 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140409182324.GA778@thunk.org>
References: <20140404134429.GB26806@quack.suse.cz> <CAJfpegsJd9d8NTmwozJ+u_ZS-SnUwAQFwAne6P1KqG=VZeZSTA@mail.gmail.com> <20140404234358.GE10275@thunk.org> <CAJfpegv_Ng1cXbpCqicG4e3UdGK3uiDtVB4KzfRQOhDq_uhZOw@mail.gmail.com> <20140407140745.GA8855@thunk.org> <CAMuHMdVHyAJwJv5nh+nQUOQJk6=2+Rr+pEqAZPgJUsA7A9A3hQ@mail.gmail.com> <20140408134740.GB28822@thunk.org> <CAMuHMdW8xkBFJ5-E04rVhDk+CSubHut+kx3P6cYCn0dMhQdb-Q@mail.gmail.com> <53457B80.1080307@zytor.com> <CAMuHMdU9ZcCzRWk2NWfdx54Uox=C=MaR5t8sD2icUpE_xtr8cA@mail.gmail.com> <20140409182324.GA778@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [GIT PULL] ext4 changes for 3.15
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 09 Apr 2014 12:19:52 -0700
To: "Theodore Ts'o" <tytso@mit.edu>, Geert Uytterhoeven <geert@linux-m68k.org>
CC: Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Message-ID: <7cc6f198-832f-4af7-82ea-2b89ad737885@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is quite frankly ridiculous how much work it takes to wire up a new system call.  It should be possible to do it across architectures without all this crap.

On April 9, 2014 11:23:24 AM PDT, Theodore Ts'o <tytso@mit.edu> wrote:
>On Wed, Apr 09, 2014 at 07:48:32PM +0200, Geert Uytterhoeven wrote:
>> >
>> > I'm missing context here, but as an x86 maintainer I have no
>intention
>> > of allowing system calls that aren't x86-specific to be added to
>x86-64
>> > only.
>> 
>> commit 520c8b16505236fc82daa352e6c5e73cd9870cff
>> Author: Miklos Szeredi <mszeredi@suse.cz>
>> Date:   Tue Apr 1 17:08:42 2014 +0200
>> 
>>     vfs: add renameat2 syscall
>> 
>> It was added to arch/x86/syscalls/syscall_64.tbl only.
>
>To be fair, part of the problem is that we don't have good
>documentation about best practices in what people should do if adding
>new system calls.  (i.e., creating a man page and pulling in Michael
>Kerrisk, adding tests, wiring up both x86_64 and i386, sending mail to
>linux-arch, the scripts/checksyscalls.sh script, etc.)
>
>I'll confess to being ignorant about the checksyscalls.sh script, and
>while I had known about the existence of the linux-arch list, I had
>forgotten about it, so if I had tried to add a new system call, it's
>likely I would have missed at one or more of these steps.
>
>       	       	    	      	     - Ted
>
>
>
>
>> 
>> Gr{oetje,eeting}s,
>> 
>>                         Geert
>> 
>> --
>> Geert Uytterhoeven -- There's lots of Linux beyond ia32 --
>geert@linux-m68k.org
>> 
>> In personal conversations with technical people, I call myself a
>hacker. But
>> when I'm talking to journalists I just say "programmer" or something
>like that.
>>                                 -- Linus Torvalds

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.

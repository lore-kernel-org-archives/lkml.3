Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbbAJWqB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 17:46:01 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41925 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbbAJWqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 17:46:00 -0500
Date: Sat, 10 Jan 2015 23:45:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 2/4] x86: ia32entry.S: fix wrong symbolic constant usage:
 R11->ARGOFFSET
Message-ID: <20150110224556.GK12218@pd.tnic>
References: <1420927210-19738-1-git-send-email-dvlasenk@redhat.com>
 <1420927210-19738-3-git-send-email-dvlasenk@redhat.com>
 <CALCETrWsT75a1Mh61BCEO41CAEz1SWJTuVjkRP=60kr=21T3OQ@mail.gmail.com>
 <CA+55aFwTJHOtMh7CMctVojO+4iy-s1UsoLD6tVukeEhdAPM44A@mail.gmail.com>
 <20150110223519.GI12218@pd.tnic>
 <CA+55aFy37dKJ_g_kDsQrkRxLFePw2tT3+tuXawp8MJOgETC+UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFy37dKJ_g_kDsQrkRxLFePw2tT3+tuXawp8MJOgETC+UQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 02:41:07PM -0800, Linus Torvalds wrote:
> On Sat, Jan 10, 2015 at 2:35 PM, Borislav Petkov <bp@alien8.de> wrote:
> >
> > Haha, Linus just made you maintainer of entry_64.S :-)
> 
> Just going by
> 
>     git shortlog --no-merges --since=6.months arch/x86/kernel/entry_64.S
> 
> and looking at the kind of changes are going on, I really think a
> "tag, you're it" to Andy is a reasonable thing to do.
> 
> I just hope he's stupid^Wambitious enough to fall for it.

I'm sure he will, he's doing nuts stuff anyway to that file but it seems
to work so far :-)

You should take a look at this other thing too, using SYSRET to return
from exceptions:

https://lkml.kernel.org/r/49394403b8b12486a6b9c9c70b72bd9f5dce7364.1415403984.git.luto@amacapital.net

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

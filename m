Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbbAJWlJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 17:41:09 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:46877 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbbAJWlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 17:41:08 -0500
MIME-Version: 1.0
In-Reply-To: <20150110223519.GI12218@pd.tnic>
References: <1420927210-19738-1-git-send-email-dvlasenk@redhat.com>
	<1420927210-19738-3-git-send-email-dvlasenk@redhat.com>
	<CALCETrWsT75a1Mh61BCEO41CAEz1SWJTuVjkRP=60kr=21T3OQ@mail.gmail.com>
	<CA+55aFwTJHOtMh7CMctVojO+4iy-s1UsoLD6tVukeEhdAPM44A@mail.gmail.com>
	<20150110223519.GI12218@pd.tnic>
Date: Sat, 10 Jan 2015 14:41:07 -0800
X-Google-Sender-Auth: RFxMQ2uWcwQSSH4kFqwUDMWvhEM
Message-ID: <CA+55aFy37dKJ_g_kDsQrkRxLFePw2tT3+tuXawp8MJOgETC+UQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] x86: ia32entry.S: fix wrong symbolic constant usage: R11->ARGOFFSET
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 2:35 PM, Borislav Petkov <bp@alien8.de> wrote:
>
> Haha, Linus just made you maintainer of entry_64.S :-)

Just going by

    git shortlog --no-merges --since=6.months arch/x86/kernel/entry_64.S

and looking at the kind of changes are going on, I really think a
"tag, you're it" to Andy is a reasonable thing to do.

I just hope he's stupid^Wambitious enough to fall for it.

                        Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaFFVNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:13:07 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:35596 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaFFVNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:13:06 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrWA92Q4ro9eaRkUrebjgQT7B2uj+bK81m9byZnDY_eMxA@mail.gmail.com>
References: <201406042235.s54MZgwP020553@terminus.zytor.com>
	<20140606140017.afb7f91142f66cb3dd13c186@linux-foundation.org>
	<CA+55aFyKTbBUM4DJukmW5fiH213D0FbVmrreR9wOtMRmmijQ9Q@mail.gmail.com>
	<CALCETrWA92Q4ro9eaRkUrebjgQT7B2uj+bK81m9byZnDY_eMxA@mail.gmail.com>
Date: Fri, 6 Jun 2014 14:13:04 -0700
X-Google-Sender-Auth: C7AIHcdlH9gq1mN45uQXLO84Mgk
Message-ID: <CA+55aFx8ezbe-mCYWp6kM8Nh3oUQd_+SNz6mLoGQtMVDk3EALA@mail.gmail.com>
Subject: Re: [GIT PULL] x86/vdso changes for v3.16
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        Stefani Seibold <stefani@seibold.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavel Emelyanov <xemul@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 2:09 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> The only real downside to that would be the chance of bitrot if that
> code isn't getting used on native builds.

Sure. Does anybody really care?

You could obviously just open-code the things, but the fact is,
"le64toh()" isn't exactly a standard function anyway, so now that I
see it needed I go "yeah, that's clearly completely unacceptable".

I'd much rather say "screw cross-compiling" (because let's face it,
nobody sane cross-compiles x86 on anything else) than say "screw old
machines".

            Linus

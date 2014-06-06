Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaFFVOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:14:42 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:53257 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaFFVOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:14:41 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFx8ezbe-mCYWp6kM8Nh3oUQd_+SNz6mLoGQtMVDk3EALA@mail.gmail.com>
References: <201406042235.s54MZgwP020553@terminus.zytor.com>
 <20140606140017.afb7f91142f66cb3dd13c186@linux-foundation.org>
 <CA+55aFyKTbBUM4DJukmW5fiH213D0FbVmrreR9wOtMRmmijQ9Q@mail.gmail.com>
 <CALCETrWA92Q4ro9eaRkUrebjgQT7B2uj+bK81m9byZnDY_eMxA@mail.gmail.com> <CA+55aFx8ezbe-mCYWp6kM8Nh3oUQd_+SNz6mLoGQtMVDk3EALA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 6 Jun 2014 14:14:20 -0700
Message-ID: <CALCETrWydbJr01ac1_Vdm3H6QdN2WJU2qcgJiZgO_UK+4Qf+0w@mail.gmail.com>
Subject: Re: [GIT PULL] x86/vdso changes for v3.16
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
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

On Fri, Jun 6, 2014 at 2:13 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Jun 6, 2014 at 2:09 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> The only real downside to that would be the chance of bitrot if that
>> code isn't getting used on native builds.
>
> Sure. Does anybody really care?
>
> You could obviously just open-code the things, but the fact is,
> "le64toh()" isn't exactly a standard function anyway, so now that I
> see it needed I go "yeah, that's clearly completely unacceptable".
>
> I'd much rather say "screw cross-compiling" (because let's face it,
> nobody sane cross-compiles x86 on anything else) than say "screw old
> machines".

Tell that to Stephen Rothwell, who apparently cross-compiles x86 on
ppc on a regular basis :)

I'll send a patch.

--Andy

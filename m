Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981Ab3FDHO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:14:59 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:37513 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab3FDHOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:14:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130603112859.7a5ad3a2129493c8c5cd0a48@canb.auug.org.au>
References: <CAMuHMdV8gJew_x1+L3O51sB=JU_EvJ-Y05JxKSsXUi+B43HAJA@mail.gmail.com>
	<CAMuHMdXQZcanJLGG8bs7u1CRb2z00Ho-kv4s5044pDDeUvoKeQ@mail.gmail.com>
	<CAMuHMdV5t3BGNYNzCyEH-dYikAtEr2A+BckPi9QtgAUEJDMM0w@mail.gmail.com>
	<20130603112859.7a5ad3a2129493c8c5cd0a48@canb.auug.org.au>
Date: Tue, 4 Jun 2013 09:14:52 +0200
X-Google-Sender-Auth: eDrO8UGyP6Za--dQE5Aqah06Uj4
Message-ID: <CAMuHMdVsJVP5--nzEABMS+epY2vkR7G40OT=b43vtiifZTcMHg@mail.gmail.com>
Subject: Re: Exotic architecture fixes
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Lennox Wu <lennox.wu@gmail.com>, linux-c6x-dev@linux-c6x.org,
        Cris <linux-cris-kernel@axis.com>, linux@openrisc.net,
        =?UTF-8?Q?H=C3=A5vard_Skinnemoen?= <hskinnemoen@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 3:28 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Sun, 2 Jun 2013 21:39:38 +0200 Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> On Tue, May 28, 2013 at 11:38 AM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>> > On Thu, May 23, 2013 at 10:09 PM, Geert Uytterhoeven
>> > <geert@linux-m68k.org> wrote:
>> >> I created a branch where I collected several exotic architecture fixes
>> >> (and a few
>> >> other trivial fixes):
>> >>
>> >>   git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git exotic-arch-fixes
>> >>
>> >> Several of these have been ack'ed (cfr. *-indicators below).
>> >> If you reject any of the commits, please scream.
>> >> If you want to take any of them yourself, please do so.
>> >>
>> >> I intend to merge this into my for-next branch after the release of v3.10-rc4,
>> >> and ask Linus to pull after the release of v3.10-rc5.
>>
>> I merged this in the for-next branch of my repo.
>
> Surely, your for-linus branch would have been a better choice.  And then
> maybe merge that into your for-next branch if you really needed these
> fixes to continue with m68k work?

An updated version is now in for-linus, as Linus has pulled the m68k
content on the
old for-linus branch.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

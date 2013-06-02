Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab3FBTjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 15:39:45 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:53139 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab3FBTjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 15:39:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXQZcanJLGG8bs7u1CRb2z00Ho-kv4s5044pDDeUvoKeQ@mail.gmail.com>
References: <CAMuHMdV8gJew_x1+L3O51sB=JU_EvJ-Y05JxKSsXUi+B43HAJA@mail.gmail.com>
	<CAMuHMdXQZcanJLGG8bs7u1CRb2z00Ho-kv4s5044pDDeUvoKeQ@mail.gmail.com>
Date: Sun, 2 Jun 2013 21:39:38 +0200
X-Google-Sender-Auth: X9dwIpd4_tJb02zY5wwNKd4JeoE
Message-ID: <CAMuHMdV5t3BGNYNzCyEH-dYikAtEr2A+BckPi9QtgAUEJDMM0w@mail.gmail.com>
Subject: Re: Exotic architecture fixes
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
        linux-c6x-dev@linux-c6x.org, Cris <linux-cris-kernel@axis.com>,
        linux@openrisc.net,
        =?UTF-8?Q?H=C3=A5vard_Skinnemoen?= <hskinnemoen@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 11:38 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Thu, May 23, 2013 at 10:09 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> I created a branch where I collected several exotic architecture fixes
>> (and a few
>> other trivial fixes):
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git exotic-arch-fixes
>>
>> Several of these have been ack'ed (cfr. *-indicators below).
>> If you reject any of the commits, please scream.
>> If you want to take any of them yourself, please do so.
>>
>> I intend to merge this into my for-next branch after the release of v3.10-rc4,
>> and ask Linus to pull after the release of v3.10-rc5.

I merged this in the for-next branch of my repo.

>> Geert Uytterhoeven (32):
>>       cris: Switch cris to drivers/Kconfig
>
> JFYI, this has a trivial conflict with "CRIS: drop unused Kconfig symbols"
> in -next.

Stephen: cris/for-next and m68k/for-next removed two different hunks from
arch/cris/arch-v32/drivers/Kconfig. To resolve the conflict, just remove both.
Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

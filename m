Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab3ALUwL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 15:52:11 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:37990 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab3ALUwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 15:52:10 -0500
MIME-Version: 1.0
In-Reply-To: <20130112183619.GC10630@liondog.tnic>
References: <CA+5PVA6nKNZY70UoeDUhQo9Rj4Ck+k+XTHL++gwErgzqAdy6Aw@mail.gmail.com>
 <20121121125310.00625f55@pyramind.ukuu.org.uk> <CA+5PVA5iQwYOcoSYtLOoRBHaTNJANdv+X-C78474n3SzZg_m9w@mail.gmail.com>
 <CA+1xoqe0G4rha5bDcoQQUcACYbQ8BCO7AE_JE8z5VjJLeNUdyA@mail.gmail.com>
 <CAM_iQpWLgnxQR+oYD+Dnh9NprR1-QLjXa6T+dtHUs3A-_N2wmQ@mail.gmail.com>
 <CA+1xoqf0d5ckDZ3o1-Y+qd61nvVA7EECeH20U+WjDpNVb4E=pw@mail.gmail.com>
 <20121227045301.GB17472@x1.alien8.de> <20121228115022.GA28009@S2101-09.ap.freescale.net>
 <20121228124026.GB12918@x1.alien8.de> <alpine.LRH.2.00.1301071037010.5443@twin.jikos.cz>
 <20130112183619.GC10630@liondog.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 12 Jan 2013 12:51:49 -0800
X-Google-Sender-Auth: WIuvefDxZQxvIWOx26rb_ob8eSY
Message-ID: <CA+55aFw163CwK_MmUKY7zGFeck+Rxk_xs=BDrCAFpg-xac3vmQ@mail.gmail.com>
Subject: Re: [PATCH] fb: Rework locking to fix lock ordering on takeover
To: Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <florianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 10:36 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Jan 07, 2013 at 10:37:15AM +0100, Jiri Kosina wrote:
>> Still seeing it with current Linus' tree.
>>
>>         Tested-by: Jiri Kosina <jkosina@suse.cz>
>>
>> Anyone applying this, please?
>
> Yeah, I'm still seeing it in -rc3. Linus, can you pick up Alan's patch
> from https://patchwork.kernel.org/patch/1757061/ please?

Christ people.

I already reported that it DOES NOT EVEN COMPILE. See the other thread
here on lkml ("Re: 3.8-rc2: EFI framebuffer lock inversion...").

Alan apparently doesn't care about the patch he wrote to even bother
fixing that, and the only person who does seem to care enough to carry
two fixes around (Andrew) apparently doesn't feel that he's
comfortable forwarding it to me (he's been sending other patches, so
it's not like Andrew is offline either)..

I'm not picking up random patches from people who don't care enough
about those patches to even bother fixing compile errors when
reportyed and didn't even send them to me to begin with.

So I'm trusting that Andrew is right, and is waiting for something.

                      Linus

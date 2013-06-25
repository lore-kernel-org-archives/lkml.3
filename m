Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab3FYVWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:22:46 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:41106 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3FYVWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:22:45 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130625205731.GA14074@free.fr>
References: <CA+icZUVcWAmbRGXqrbkPXux6hSpYVM2yAPfbv_q8Faf348TGyw@mail.gmail.com>
	<CA+icZUUta_HBtbpEOCsdPDRor1rvSNk46Wk=dHdvA6mAp61c1A@mail.gmail.com>
	<20130625205731.GA14074@free.fr>
Date: Tue, 25 Jun 2013 23:22:40 +0200
Message-ID: <CA+icZUWfi+PG35Gs9Auefz1Qg7HuD1pAhpy7Uu+i83aNvDNs=g@mail.gmail.com>
Subject: Re: linux-next: Tree for Jun 25 [ kbuild or rapidio? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 10:57 PM, Yann E. MORIN <yann.morin.1998@free.fr> wrote:
> Sedat, All,
>
> On 2013-06-25 11:28 +0200, Sedat Dilek spake thusly:
>> On Tue, Jun 25, 2013 at 11:17 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> > On Tue, Jun 25, 2013 at 10:55 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> [--SNIP--]
>> >> Not sure what's going on, but I get this with today's Linux-Next.
>> >> ( Yesterday's next-20130624 was OK. )
>> >>
>> >> $ LANG=C LC_ALL=C  yes "" | make oldconfig && LANG=C LC_ALL=C make
>> >> silentoldconfig </dev/null
> [--SNIP--]
>> >> RapidIO support (RAPIDIO) [Y/n/?] y
>> >>   IDT Tsi721 PCI Express SRIO Controller support (RAPIDIO_TSI721) [Y/n/?] y
>> >>   Discovery timeout duration (seconds) (RAPIDIO_DISC_TIMEOUT) [30] 30
>> >>   Enable RapidIO Input/Output Ports (RAPIDIO_ENABLE_RX_TX_PORTS) [N/y/?] n
>> >>   DMA Engine support for RapidIO (RAPIDIO_DMA_ENGINE) [Y/n/?] y
>> >>   RapidIO subsystem debug messages (RAPIDIO_DEBUG) [N/y/?] n
>> >>   Enumeration method [M/y/?] (NEW) aborted!
>> >>
>> >> Console input/output is redirected. Run 'make oldconfig' to update
>> >> configuration.
>> >>
>> >> make[1]: *** [silentoldconfig] Error 1
>> >> make: *** [silentoldconfig] Error 2
> [--SNIP--]
>> So, it's a kbuild issue (info to the rapidio maintainers).
>
> To be true, it's a kconfig (not kbuild) issue I introduced when trying
> to fix choice randomisation.
>

I was not precise enough "linux-kbuild" (I know there exists kbuild
and kconfig).

BTW, there is another GIT tree (from rostedt) containing kconfig stuff
in Linux-Next (seems not to be very active).

kbuild		git	git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git#for-next
kconfig		git	git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-kconfig.git#for-next

Confusing :-).

- Sedat -

http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/Next/Trees#n96
http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/Next/Trees#n97

> Regards,
> Yann E. MORIN.
>
> --
> .-----------------.--------------------.------------------.--------------------.
> |  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
> | +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
> | +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
> | http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
> '------------------------------^-------^------------------^--------------------'

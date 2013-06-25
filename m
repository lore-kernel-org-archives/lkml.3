Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab3FYU5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:57:40 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:43808 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab3FYU5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:57:37 -0400
Date: Tue, 25 Jun 2013 22:57:31 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>
Subject: Re: linux-next: Tree for Jun 25 [ kbuild or rapidio? ]
Message-ID: <20130625205731.GA14074@free.fr>
References: <CA+icZUVcWAmbRGXqrbkPXux6hSpYVM2yAPfbv_q8Faf348TGyw@mail.gmail.com>
 <CA+icZUUta_HBtbpEOCsdPDRor1rvSNk46Wk=dHdvA6mAp61c1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+icZUUta_HBtbpEOCsdPDRor1rvSNk46Wk=dHdvA6mAp61c1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat, All,

On 2013-06-25 11:28 +0200, Sedat Dilek spake thusly:
> On Tue, Jun 25, 2013 at 11:17 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > On Tue, Jun 25, 2013 at 10:55 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
[--SNIP--]
> >> Not sure what's going on, but I get this with today's Linux-Next.
> >> ( Yesterday's next-20130624 was OK. )
> >>
> >> $ LANG=C LC_ALL=C  yes "" | make oldconfig && LANG=C LC_ALL=C make
> >> silentoldconfig </dev/null
[--SNIP--]
> >> RapidIO support (RAPIDIO) [Y/n/?] y
> >>   IDT Tsi721 PCI Express SRIO Controller support (RAPIDIO_TSI721) [Y/n/?] y
> >>   Discovery timeout duration (seconds) (RAPIDIO_DISC_TIMEOUT) [30] 30
> >>   Enable RapidIO Input/Output Ports (RAPIDIO_ENABLE_RX_TX_PORTS) [N/y/?] n
> >>   DMA Engine support for RapidIO (RAPIDIO_DMA_ENGINE) [Y/n/?] y
> >>   RapidIO subsystem debug messages (RAPIDIO_DEBUG) [N/y/?] n
> >>   Enumeration method [M/y/?] (NEW) aborted!
> >>
> >> Console input/output is redirected. Run 'make oldconfig' to update
> >> configuration.
> >>
> >> make[1]: *** [silentoldconfig] Error 1
> >> make: *** [silentoldconfig] Error 2
[--SNIP--]
> So, it's a kbuild issue (info to the rapidio maintainers).

To be true, it's a kconfig (not kbuild) issue I introduced when trying
to fix choice randomisation.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbaBMFev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 00:34:51 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:45558 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaBMFet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 00:34:49 -0500
Date: Thu, 13 Feb 2014 14:34:46 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] ARM: shmobile: r8a7790/Lager QSPI SoC/board
 integration
Message-ID: <20140213053443.GA17183@verge.net.au>
References: <1392029254-15400-1-git-send-email-geert@linux-m68k.org>
 <CANqRtoQZBTYXwDcfzxqs9X-o2Yftvr=TM4dLgeMagr-LGdm1uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANqRtoQZBTYXwDcfzxqs9X-o2Yftvr=TM4dLgeMagr-LGdm1uw@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 02:01:01PM +0900, Magnus Damm wrote:
> Hi Geert, Simon,
> 
> On Mon, Feb 10, 2014 at 7:47 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> >         Hi Simon, Magnus,
> >
> > The following patch series completes r8a7790 SoC and Lager board
> > integration for the Renesas Quad Serial Peripheral Interface. It brings
> > r8a7790/Lager to the same support level as r8a7791/Koelsch, allowing access
> > to the Spansion s25fl512s SPI FLASH for both legacy and multi-platform
> > kernels.
> >
> >     [1/7] pinctrl: sh-pfc: r8a7790: Add QSPI pin groups
> >     [2/7] ARM: shmobile: lager legacy: Add QSPI pinmux
> >     [3/7] ARM: shmobile: r8a7790 dtsi: Add QSPI node
> >     [4/7] ARM: shmobile: lager dts: Add QSPI nodes
> >     [5/7] ARM: shmobile: lager defconfig: Enable RSPI and MTD_M25P80
> 
> Thanks a lot for this! All patches included in this series look great to me.
> 
> I noticed that 1/7 turned into a v2, so feel free to omit or include
> the below ack.
> 
> Acked-by: Magnus Damm <damm@opensource.se>
> 
> >     [6/7] ARM: shmobile: lager legacy: Enable Quad SPI transfers for the SPI
> >           FLASH
> >     [7/7] ARM: shmobile: lager dts: Enable Quad SPI transfers for the SPI
> >          FLASH
> >
> > Please do _not_ apply patches [6/7] and [7/7] yet, as these have a runtime
> > dependency on Quad SPI support in the RSPI/QSPI driver, which is queued up
> > in the linux-spi tree for v3.15.
> 
> That makes sense, thanks for pointing that out. You still have my Ack
> though, so please include that when you resend.
> 
> Simon, can you please pick up 2-5?

Done.

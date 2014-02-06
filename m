Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbaBFLnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 06:43:16 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:55727 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbaBFLnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 06:43:14 -0500
Date: Thu, 6 Feb 2014 20:43:11 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-spi@vger.kernel.org,
        SH-Linux <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] ARM: shmobile: RSPI RZ and QSPI SoC and board
 integration
Message-ID: <20140206114305.GA26662@verge.net.au>
References: <1391527445-14881-1-git-send-email-geert@linux-m68k.org>
 <20140205005631.GA7664@verge.net.au>
 <CANqRtoSrLV3PiUdbUQv9gTsM-p8tiqRvSza-=D9hG5fVn-CR0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANqRtoSrLV3PiUdbUQv9gTsM-p8tiqRvSza-=D9hG5fVn-CR0A@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 07:36:17PM +0900, Magnus Damm wrote:
> On Wed, Feb 5, 2014 at 9:56 AM, Simon Horman <horms@verge.net.au> wrote:
> > Magnus, could you Ack these or otherwise?
> >
> > On Tue, Feb 04, 2014 at 04:23:54PM +0100, Geert Uytterhoeven wrote:
> >>       Hi Simon, Magnus,
> >>
> >> This patch series contains SoC and board integration for
> >>   1. RSPI in the r7s72100 aka RZ/A1H SoC on the Genmai reference board,
> >>   2. QSPI in the r8a7791 aka R-Car M2 SoC on the Koelsch reference board.
> >> It was rebased on top of renesas-devel-v3.14-rc1-20140204.
> >>
> >> It was tested on the r7s72100-based Genmai reference board using loopback
> >> mode, and on the r8a7791-based Koelsch reference board using the Spansion
> >> s25fl512s SPI FLASH.
> >>
> >>   - [v5 01/11] ARM: shmobile: r7s72100 clock: Add RSPI clocks
> >>   - [v5 02/11] ARM: shmobile: genmai legacy: Add RSPI support
> >>   - [v3 03/11] ARM: shmobile: genmai defconfig: Enable RSPI
> >>   - [v3 04/11] ARM: shmobile: r7s72100 clock: Add RSPI clocks for DT
> >>   - [v5 05/11] ARM: shmobile: r7s72100 dtsi: Add RSPI nodes
> >>   - [v4 06/11] ARM: shmobile: r8a7791 clock: add QSPI clocks
> >>   - [v4 07/11] ARM: shmobile: koelsch legacy: Add QSPI support
> >>   - [v4 08/11] ARM: shmobile: koelsch defconfig: Enable RSPI and
> >>   - [v3 09/11] ARM: shmobile: r8a7791 dtsi: Add QSPI node
> >>   - [v3 10/11] ARM: shmobile: koelsch dts: Add QSPI nodes
> >>   - [v2 11/11] ARM: shmobile: lager legacy: Switch QSPI to named IRQs
> >
> > Above I see v2, v3, v4 and v5 patches.
> >
> > While I can make sense of this it makes it cumbersome to refer to the
> > series as a whole.
> >
> > Bob, can you take a look at '"[PATCH 00/11] ARM: shmobile: RSPI RZ and
> > QSPI SoC and board", posted on Tuesday the 2nd, which includes v2, v3,
> > v4 and v5 patches'?
> >
> > What would make my life easier would be if the entire series was v5 and
> > all the patches contained in it were v5. Then I could just ask Bob to look
> > at "[PATCH v5 00/11] ARM: shmobile: RSPI RZ and QSPI SoC and board"
> >
> > There is no Bob but I do ask people these kind of questions :)
> 
> Simon, Geert, Bob,
> 
> I've now gone through these patches and I think they look great. My
> apologies for slow handling.
> 
> Acked-by: Magnus Damm <damm@opensource.se>

Thanks, I have queued these up.

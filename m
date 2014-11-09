Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaKIA6H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 19:58:07 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:35344 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbaKIA6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 19:58:05 -0500
Date: Sat, 8 Nov 2014 16:58:02 -0800
From: Olof Johansson <olof@lixom.net>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-arm-kernel@lists.infradead.org,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, stable@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: zynq: Enable PL clocks for Parallella
Message-ID: <20141109005802.GE13855@quad.lixom.net>
References: <1415294531-8942-1-git-send-email-afaerber@suse.de>
 <eca8ae5de8184151b03d3fd8d23c62a7@BY2FFO11FD010.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eca8ae5de8184151b03d3fd8d23c62a7@BY2FFO11FD010.protection.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 07:44:16AM +0100, Michal Simek wrote:
> On 11/06/2014 06:22 PM, Andreas Färber wrote:
> > The Parallella board comes with a U-Boot bootloader that loads one of
> > two predefined FPGA bitstreams before booting the kernel. Both define an
> > AXI interface to the on-board Epiphany processor.
> > 
> > Enable clocks FCLK0..FCLK3 for the Programmable Logic by default.
> > 
> > Otherwise accessing, e.g., the ESYSRESET register freezes the board,
> > as seen with the Epiphany SDK tools e-reset and e-hw-rev, using /dev/mem.
> > 
> > Cc: <stable@vger.kernel.org> # 3.17.x
> > Signed-off-by: Andreas Färber <afaerber@suse.de>
> > ---
> >  Michal/Olof, please consider this trivial patch as a fix for 3.18.
> 
> Acked-by: Michal Simek <michal.simek@xilinx.com>
> 
> Olof, Arnd: Can you please pick this directly?

Done, applied to fixes.


-Olof

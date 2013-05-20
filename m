Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab3ETSP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 14:15:56 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:58737 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab3ETSPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 14:15:54 -0400
Date: Mon, 20 May 2013 20:15:49 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Mike Turquette <mturquette@linaro.org>,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/10] clk: mvebu: restructure SoC clock drivers
Message-ID: <20130520201549.475e50d0@skate>
In-Reply-To: <20130520175827.GC31290@titan.lakedaemon.net>
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20130516184658.0650f838@skate>
	<20130520175827.GC31290@titan.lakedaemon.net>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jason Cooper,

On Mon, 20 May 2013 13:58:27 -0400, Jason Cooper wrote:

> > I've tested on Armada 370 DB (after reverting the ARM core patch
> > that prevents this platform from booting) and the Armada XP DB.
> > Both boards boot fine, and detect PCIe devices as they should.
> > 
> > There is some conflict between this set of commits and the two
> > commits that modify the PCIe clocks in my PCIe series. I've pushed
> > a branch at
> > https://github.com/MISL-EBU-System-SW/mainline-public/tree/marvell-pcie-v10-and-seb-clks
> > which has the mvebu PCIe stuff + Sebastian patches on top of it,
> > with the conflicts resolved. The tricky thing is that since
> > Sebastian is adding new clock files, and then removing the old
> > ones, it's pretty easy to "loose" the changes the two PCIe clock
> > patches are doing. The branch above works on Armada 370/XP, so you
> > can compare the clock files if needed.
> 
> hmm, in my haste yesterday, I did this in the opposite order (clk,
> then pcie on top).  I'm going to reshuffle them because I don't want
> pcie depending on and waiting for this clock series to be ready :)

Ok. Either way is fine with me, but it's true that chronologically, the
PCIe stuff has been around for way more time than the clk
restructure patches.

> The good news is everything (except kirkwood-pcie, ran out of time)
> made it through linux-next!  Also, kisskb is now building
> mvebu_defconfig in addition to all the other ones.

Ok. Gregory can give more details, but I believe we are also building
daily linux-next and Linus master for the mvebu_defconfig.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

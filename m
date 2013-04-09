Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935624Ab3DIXzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:55:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44180 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935465Ab3DIXzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:55:45 -0400
Date: Wed, 10 Apr 2013 01:55:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, Joerg Reisenweber <joerg@openmoko.org>,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH v2] New Nokia RX-51 power supply battery driver
Message-ID: <20130409235539.GA7873@amd.pavel.ucw.cz>
References: <19040462.WFXWijAIDd@pali>
 <20130330183526.GA21198@lizard>
 <20130330214229.GA4322@amd.pavel.ucw.cz>
 <201303302351.06611@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201303302351.06611@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI!

> kernel git repository with n900 patches (now based on v3.8-rc3):
> https://gitorious.org/linux-n900/linux-n900

Ok, I am getting this with defconfig:

  CC      arch/arm/mach-omap2/board-rx51-peripherals.o
arch/arm/mach-omap2/board-rx51-peripherals.c:1040: error: unknown
field ‘arb_mode’ specified in initializer
arch/arm/mach-omap2/board-rx51-peripherals.c:1040: warning: missing
braces around initializer
arch/arm/mach-omap2/board-rx51-peripherals.c:1040: warning: (near
initialization for ‘rx51_ssi_cl[1].tx_cfg.<anonymous>’)
make[1]: *** [arch/arm/mach-omap2/board-rx51-peripherals.o] Error 1
make: *** [arch/arm/mach-omap2] Error 2

I hope I have right tree:

commit b6537e4a86afe74cc67dc3f96e145024e0638d0c
Author: Pali Rohár <pali.rohar@gmail.com>
Date:   Sun Feb 17 22:37:21 2013 +0100

    rx51_defconfig: Use smiapp driver instead smia-sensor driver for
    front webcam

> open source flasher 0xFFFF (working on x86-64 too) which can load 
> kernel and initfs via usb to n900 RAM without flashing nand:
> https://gitorious.org/0xffff/0xffff

This compiles ok, lets see if it works.

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

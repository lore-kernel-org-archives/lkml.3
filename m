Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaC1KOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:14:09 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:54806 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaC1KOG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:14:06 -0400
Date: Fri, 28 Mar 2014 11:13:50 +0100
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Huang Shijie <b32955@freescale.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Rutland <mark.rutland@arm.com>, Shawn Guo <shawn.guo@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, Rob Landley <rob@landley.net>,
        Kumar Gala <galak@codeaurora.org>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCHv2 1/1] mtd: gpmi: make blockmark swapping optional
Message-ID: <20140328111350.003b9fce@ipc1.ka-ro>
In-Reply-To: <53354329.2020909@freescale.com>
References: <532BCFCC.4080205@freescale.com>
	<1395399017-19005-1-git-send-email-LW@KARO-electronics.de>
	<20140324095902.GB11377@localhost>
	<20140326095156.3e5585b8@ipc1.ka-ro>
	<5332AEE7.2040402@freescale.com>
	<20140326125502.0e8d0657@ipc1.ka-ro>
	<20140327095956.GA29623@localhost>
	<20140327132109.06258526@ipc1.ka-ro>
	<5334D9F7.2030001@freescale.com>
	<20140328091646.1ce03f90@ipc1.ka-ro>
	<53353524.9020605@freescale.com>
	<20140328100158.042a3d68@ipc1.ka-ro>
	<533541DE.7020606@freescale.com>
	<53354329.2020909@freescale.com>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Huang Shijie wrote:
> 于 2014年03月28日 17:33, Huang Shijie 写道:
> > 于 2014年03月28日 17:01, Lothar Waßmann 写道:
> >> There is no need for the ROM code to access any other partition than
> >> the bootloader itself. Thus Linux can perfectly well be booted from
> > Assume the ROM only access the partition which contains the 
> > bootloader, and
> > the ROM does the swapping for the pages(but we do not do the swapping 
> > to these pages),
> I mean the kernel do not do the swapping when we burn the uboot to the NAND.
> 
The kernel need not be able to write the bootloader to NAND. 
If you want a kernel that can do it, you just need to boot it with one
line in the DTB removed.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________

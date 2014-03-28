Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaC1Jca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 05:32:30 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:54778 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaC1Jc0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 05:32:26 -0400
Date: Fri, 28 Mar 2014 10:31:47 +0100
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Huang Shijie <b32955@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        <linux-mtd@lists.infradead.org>, Shawn Guo <shawn.guo@freescale.com>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 1/1] mtd: gpmi: make blockmark swapping optional
Message-ID: <20140328103147.3fdadfd7@ipc1.ka-ro>
In-Reply-To: <53354057.6030004@freescale.com>
References: <1395399017-19005-1-git-send-email-LW@KARO-electronics.de>
	<20140324095902.GB11377@localhost>
	<20140326095156.3e5585b8@ipc1.ka-ro>
	<5332AEE7.2040402@freescale.com>
	<20140326125502.0e8d0657@ipc1.ka-ro>
	<20140327095956.GA29623@localhost>
	<20140327132109.06258526@ipc1.ka-ro>
	<5334D9F7.2030001@freescale.com>
	<20140328091646.1ce03f90@ipc1.ka-ro>
	<53353524.9020605@freescale.com>
	<20140328090023.GB17250@pengutronix.de>
	<53354057.6030004@freescale.com>
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
> 于 2014年03月28日 17:00, Sascha Hauer 写道:
> > - disables swapping of BB marks in the FCB the ROM won't swap bytes.
> We can not disable the swapping in the FCB in the imx28.
> The DISBBM bit in the FCB does _NOT_ exit in the imx28's FCB.
> 
The Linux kernel does not have any business with the FCB, so it is
completely irrelevant for Linux whether byte swapping can be disabled
in the FCB or not.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________

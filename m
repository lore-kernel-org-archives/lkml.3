Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbaCTKKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 06:10:37 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:51931 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaCTKKf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 06:10:35 -0400
Date: Thu, 20 Mar 2014 11:09:14 +0100
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Huang Shijie <b32955@freescale.com>
Cc: <y@KARO-electronics.de>, Arnd Bergmann <arnd@arndb.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <b47714@freescale.com>
Subject: Re: [PATCH] mtd: gpmi: make blockmark swapping optional
Message-ID: <20140320110914.731db7cf@ipc1.ka-ro>
In-Reply-To: <532AB94D.1050406@freescale.com>
References: <1395235406-13449-1-git-send-email-y>
	<532AB1A2.9010702@freescale.com>
	<20140320102153.7106f915@ipc1.ka-ro>
	<532AB94D.1050406@freescale.com>
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
> 于 2014年03月20日 17:21, Lothar Waßmann 写道:
> > Hi,
> >
> > Huang Shijie wrote:
> >> 于 2014年03月19日 21:23, y@karo-electronics.de 写道:
> >>> configurable via DT. This is required for the Ka-Ro electronics
> >>> platforms.
> >>>
> >> If you disable the swapping, you will disable the NAND boot in actually.
> >>
> > No. All our modules do boot from NAND and none of them does the
> > swapping.
> >
> >
> It seems the NAND boot runs well by luck.
> 
> The ROM will do the swapping when it reads the BBT table written by the 
> kobs-ng (or something else?).
> 
This can be disabled by parameter in the FCB (at least according to
the i.MX6 reference Manual):
|DISBBM 172 4 If 0 ROM will swap BadBlockMarkerByte with
|             metadata[0] after reading a page using BCH40.
|             If the value set is 1 then ROM will not do
|             swapping


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________

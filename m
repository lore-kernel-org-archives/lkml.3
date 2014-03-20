Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbaCTJWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:22:51 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:51894 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379AbaCTJWr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:22:47 -0400
Date: Thu, 20 Mar 2014 10:21:53 +0100
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
        <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH] mtd: gpmi: make blockmark swapping optional
Message-ID: <20140320102153.7106f915@ipc1.ka-ro>
In-Reply-To: <532AB1A2.9010702@freescale.com>
References: <1395235406-13449-1-git-send-email-y>
	<532AB1A2.9010702@freescale.com>
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
> 于 2014年03月19日 21:23, y@karo-electronics.de 写道:
> > configurable via DT. This is required for the Ka-Ro electronics
> > platforms.
> >
> If you disable the swapping, you will disable the NAND boot in actually.
> 
No. All our modules do boot from NAND and none of them does the
swapping.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________

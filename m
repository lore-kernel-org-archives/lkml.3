Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbaCTJWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:22:17 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:51886 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091AbaCTJWI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:22:08 -0400
Date: Thu, 20 Mar 2014 10:20:29 +0100
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Juergen Beisert <jbe@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, y@KARO-electronics.de,
        Arnd Bergmann <arnd@arndb.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Huang Shijie <b32955@freescale.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH] mtd: gpmi: make blockmark swapping optional
Message-ID: <20140320102029.4327a6c0@ipc1.ka-ro>
In-Reply-To: <201403200933.39382.jbe@pengutronix.de>
References: <1395235406-13449-1-git-send-email-y>
	<201403200933.39382.jbe@pengutronix.de>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Juergen Beisert wrote:
> Hi Lothar,
> 
> On Wednesday 19 March 2014 14:23:26 y@karo-electronics.de wrote:
> > With a flash-based BBT there is no reason to move the Factory Bad
> > Block Marker from the data area buffer (to where it is mapped by the
> > GPMI NAND controller) to the OOB buffer. Thus, make this feature
> > configurable via DT. This is required for the Ka-Ro electronics
> > platforms.
> > [...]
> 
> How do you create the BBT the very first time with valuable data when the NAND 
> already contains factory bad blocks?
> 
With the flashtool that does the initial flash programming.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________

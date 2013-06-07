Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab3FGV3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 17:29:36 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:35653 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab3FGV3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 17:29:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130607205940.4816fed5@skate>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	<1370475609.20454.44.camel@localhost>
	<CAPweEDwS3tR=wh-bZJb3vqR8fVQra=3XxDitowGRdH9c7WRfmQ@mail.gmail.com>
	<1733666.lHUBcfUXq9@flatron>
	<20130606112723.71ddd70c@skate>
	<CAPweEDzW60poOYahm31aW3_A=NvZmyBPPPgM9PzdvuPJnju69A@mail.gmail.com>
	<20130607205940.4816fed5@skate>
Date: Fri, 7 Jun 2013 22:29:34 +0100
Message-ID: <CAPweEDxtC+OamcpVEQ3BULbN88hSJzKoi0fkNLBAdZD04LQCNQ@mail.gmail.com>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: "luke.leighton" <luke.leighton@gmail.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        debian-kernel@lists.debian.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 7:59 PM, Thomas Petazzoni
<thomas.petazzoni@free-electrons.com> wrote:

> Maxime will reply to this in more details, but I believe the status is:
>
>  * Interrupt controller is working.
>  * Clock drivers are working.
>  * Pinctrl is working.
>  * GPIO is working.
>  * Timer is working.
>  * UART is working
>  * Watchdog is on its way (patches posted)
>  * Ethernet is on its way (patches posted)
>  * I2C is on its way (patches posted)

 ok so i've got this now in
http://hands.com/~lkcl/allwinner_linux_proposal.txt - that leaves...
well there's quite a bit: usb, sd/mmc (both variants: they changed the
data structures around sun5i), nand (probably both - the allwinner one
and the mtd one being done, reminds me: we need full documentation on
the NAND chip), scsi, g2d - cedarx and more.

 what else should be raised, and to what benefit?

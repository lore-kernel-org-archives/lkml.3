Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab3FFJ3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 05:29:52 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:41296 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab3FFJ3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 05:29:51 -0400
Date: Thu, 6 Jun 2013 11:29:48 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
Cc: Luke Kenneth Casson Leighton <lkcl@lkcl.net>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        debian-release@lists.debian.org, debian-kernel@lists.debian.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: getting allwinner SoC support upstream (was Re: Uploading linux
 (3.9.4-1))
Message-ID: <20130606112948.7cd444a4@skate>
In-Reply-To: <CAKON4OyyRF4Z46RyJFDWUwo4L52Z8bgSH0CzDr2gDerw4iDwcw@mail.gmail.com>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	<CAKON4OyyRF4Z46RyJFDWUwo4L52Z8bgSH0CzDr2gDerw4iDwcw@mail.gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, 5 Jun 2013 16:48:27 -0400, jonsmirl@gmail.com wrote:

> >  fex covers *eeeeeevvveeerryyyythiiiing* - right from flipping the
> > multiplexing for all 3 SD/MMC cards so that you can pretend that SD0
> > is SD2 and you can specify *different* GPIOs for each to say which
> > is
> 
> You can do all of this in device tree too. If the exact syntax doesn't
> exist you can use 'allwinner,' prefixes on the node names.
> Also check out pinctrl so that it doesn't get reinvented.

Are people looking at the mainline source code?

There is already a pinctrl driver for sunxi platforms (i.e Allwinner
SoCs), it's at drivers/pinctrl/pinctrl-sunxi.c, and it's DT-based and
allows to describe the pin muxing in the Device Tree.

Cc'ing Maxime Ripard, who is the mach-sunxi maintainer in the mainline
kernel.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

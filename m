Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab3FFJ13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 05:27:29 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:41269 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab3FFJ10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 05:27:26 -0400
Date: Thu, 6 Jun 2013 11:27:23 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "luke.leighton" <luke.leighton@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        debian-kernel@lists.debian.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
Message-ID: <20130606112723.71ddd70c@skate>
In-Reply-To: <1733666.lHUBcfUXq9@flatron>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	<1370475609.20454.44.camel@localhost>
	<CAPweEDwS3tR=wh-bZJb3vqR8fVQra=3XxDitowGRdH9c7WRfmQ@mail.gmail.com>
	<1733666.lHUBcfUXq9@flatron>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Tomasz Figa,

On Thu, 06 Jun 2013 02:01:14 +0200, Tomasz Figa wrote:

> I don't see any other solution here than moving all the Allwinner
> code to DT (as it has been suggested in this thread several times
> already), as this is the only hardware description method supported
> by ARM Linux.

Have you noticed that it is already the case in mainline? My colleague
Maxime Ripard (Cc'ed) is the maintainer of the mainline Allwinner sunxi
effort. It already supports a number of boards, has a pinctrl driver, a
GPIO driver, serial port is working, network is working, I2C is
working.

All in mainline, completely Device Tree based.

So isn't this entire discussion completely moot? The mainline support
for sunxi has already started since 6 months or so, and has been Device
Tree based from day one.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

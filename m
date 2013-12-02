Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab3LBNY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:24:28 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43824 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab3LBNY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:24:26 -0500
Date: Mon, 2 Dec 2013 13:23:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: panchaxari <panchaxari.prasannamurthy@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Simek <monstr@monstr.eu>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM:INTEGRATOR: Default enable ARM_PATCH_PHYS_VIRT,
	AUTO_ZRELADDR
Message-ID: <20131202132333.GJ16735@n2100.arm.linux.org.uk>
References: <1385983731-13196-1-git-send-email-panchaxari.prasannamurthy@linaro.org> <1385983731-13196-2-git-send-email-panchaxari.prasannamurthy@linaro.org> <20131202114638.GH16735@n2100.arm.linux.org.uk> <CACRpkdZv9cZekBfJ2P1G4pMYOyAobmA2mszF=kN0Db5TC6_5+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZv9cZekBfJ2P1G4pMYOyAobmA2mszF=kN0Db5TC6_5+Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 01:57:10PM +0100, Linus Walleij wrote:
> Good point, I've also seen "[RFT]" (request for testing) in some
> cases.

Note that it still needs [PATCH] before it.  A good way to integrate it
is to use the form "[PATCH CFT n/nn]" where n/nn exists if you have a
series.

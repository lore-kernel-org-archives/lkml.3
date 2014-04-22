Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbaDVQBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:01:55 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:24825 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756902AbaDVQBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:01:41 -0400
Date: Tue, 22 Apr 2014 17:01:03 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Gregory =?iso-8859-1?Q?Cl=E9ment?= 
	<gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>
Subject: Re: [PATCH v2 0/7] of: setup dma parameters using dma-ranges and
 dma-coherent
Message-ID: <20140422160103.GG10224@arm.com>
References: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com>
 <20140419182528.414b9b2e@skate>
 <201404221702.19842.arnd@arndb.de>
 <20140422152529.GE10224@arm.com>
 <CAL_JsqJktpEBE1rAXDKX8uNSrWzgP1Scucvzrtw0auQSC=SO_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJktpEBE1rAXDKX8uNSrWzgP1Scucvzrtw0auQSC=SO_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 04:30:36PM +0100, Rob Herring wrote:
> On Tue, Apr 22, 2014 at 10:25 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > On Tue, Apr 22, 2014 at 04:02:19PM +0100, Arnd Bergmann wrote:
> >> On Saturday 19 April 2014, Thomas Petazzoni wrote:
> 
> [...]
> 
> >> I would hope we can find a way to avoid the platform notifiers for
> >> mvebu as well and come up with a generic way to express this
> >> 'semi-coherent' mode. I believe x-gene has a similar issue, and
> >> I wouldn't be surprised if there are others like this.
> >
> > The solution is for the snooping unit to detect the DSB instruction
> > (which is propagated outside the CPU) and wait for the completion of the
> > coherency work (but we need more information from the hardware guys).
> 
> If the solution was fixing broken h/w, we'd all be retired (or h/w
> designers). :)

At least they could admit it's a hardware bug and hopefully won't do the
same mistake in the future (wishful thinking ;)).

-- 
Catalin

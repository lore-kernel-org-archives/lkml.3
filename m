Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab3KROyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:54:32 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43086 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3KROy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:54:26 -0500
Date: Mon, 18 Nov 2013 14:54:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Florian Meier <florian.meier@koalo.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        devicetree <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv7] dmaengine: Add support for BCM2835
Message-ID: <20131118145400.GE16735@n2100.arm.linux.org.uk>
References: <5288E327.8050809@koalo.de> <1384768816.14845.186.camel@smile> <528A051A.7000703@koalo.de> <1384785017.14845.214.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384785017.14845.214.camel@smile>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 04:30:17PM +0200, Andy Shevchenko wrote:
> On Mon, 2013-11-18 at 13:16 +0100, Florian Meier wrote:
> > >> +	uint32_t chans_available;
> > > 
> > > Why uint32_t?
> > 
> > Because it is a bit mask of fixed length that directly comes from the
> > firmware.
> 
> Like one already told you in your i2s patch, please, change that to
> corresponding u* value, namely u32.

There's no problem with uint32_t vs u32 - either will do.  u32 is the
pre-stdint.h Linux definition of a 32-bit unsigned integer.  There's
no reason why uint32_t isn't perfectly acceptable.  It's a matter of
author taste which gets used.  (Except where modifications are to an
existing chunk of code using one or the other - where consistency then
matters more.)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab3KRWS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 17:18:57 -0500
Received: from smtprelay0079.hostedemail.com ([216.40.44.79]:40955 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751281Ab3KRWSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 17:18:53 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2
X-HE-Tag: bears59_12f4afdb15e1a
X-Filterd-Recvd-Size: 2426
Message-ID: <1384813128.17783.3.camel@joe-AO722>
Subject: Re: [PATCHv7] dmaengine: Add support for BCM2835
From: Joe Perches <joe@perches.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Florian Meier <florian.meier@koalo.de>,
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
Date: Mon, 18 Nov 2013 14:18:48 -0800
In-Reply-To: <20131118145400.GE16735@n2100.arm.linux.org.uk>
References: <5288E327.8050809@koalo.de> <1384768816.14845.186.camel@smile>
	 <528A051A.7000703@koalo.de> <1384785017.14845.214.camel@smile>
	 <20131118145400.GE16735@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-18 at 14:54 +0000, Russell King - ARM Linux wrote:
> On Mon, Nov 18, 2013 at 04:30:17PM +0200, Andy Shevchenko wrote:
> > On Mon, 2013-11-18 at 13:16 +0100, Florian Meier wrote:
> > > >> +	uint32_t chans_available;
> > > > 
> > > > Why uint32_t?
> > > 
> > > Because it is a bit mask of fixed length that directly comes from the
> > > firmware.
> > 
> > Like one already told you in your i2s patch, please, change that to
> > corresponding u* value, namely u32.
> 
> There's no problem with uint32_t vs u32 - either will do.  u32 is the
> pre-stdint.h Linux definition of a 32-bit unsigned integer.  There's
> no reason why uint32_t isn't perfectly acceptable.  It's a matter of
> author taste which gets used.  (Except where modifications are to an
> existing chunk of code using one or the other - where consistency then
> matters more.)

https://lkml.org/lkml/2006/5/2/258



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936038Ab3DINwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:52:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55210 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab3DINvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:51:46 -0400
Date: Tue, 9 Apr 2013 14:51:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Daniel Tang <dt.tangr@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "fabian@ritter-vogt.de" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH arm: initial TI-Nspire support]
Message-ID: <20130409135120.GC14496@n2100.arm.linux.org.uk>
References: <6FE4B33E-A503-4A75-AEED-831CB2C06D83@gmail.com> <4B3FD561-84FC-40CD-B747-13851692D673@gmail.com> <521DFDFC-7E9E-47EA-ACDA-C91BBDC8454E@gmail.com> <201304072323.42173.arnd@arndb.de> <CACRpkda9Nue-8Esp3cJ6u2-MJ2ZL8hH-2BnrhHwWv4GZP2VR5w@mail.gmail.com> <1365508916.24306.17.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365508916.24306.17.camel@hornet>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 01:01:56PM +0100, Pawel Moll wrote:
> So I have PL111 code almost working here, however today it depends on
> not-yet-upstream (to my knowledge) generic/common panel/display
> framework. If I'm not disturbed again I may get something done this
> week, hopefully removing the dependency.
> 
> There's also some work going on on a DRM driver for PL111, but I can't
> promise any dates.
> 
> As to PL110 I have no idea how different is it from the PL111, but
> nothing is happening about it anyway.

If you're doing PL111, then you might as well do PL110, because the two
are basically the same.  But note that all PL111's aren't equal.  Some
are closer to PL110 than the current PL111, so if you want to support
all PL111s, you also need to have the support in place for PL110.

Also note that the way the bits are assigned in the frame buffer varies
between platforms, and most certainly the TRMs documentation of colour
bitfield layouts can _not_ be relied upon.

I have considerable knowledge in this area, but as seems to be the norm
now, no one cares about that.  I'll go back to twiddling my thumbs now,
waiting for the next email to arrive.  Or maybe I'll go down to the
shops and wander around down there.  Or something.

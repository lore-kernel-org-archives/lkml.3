Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbaIXJXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:23:54 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40592 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751693AbaIXJXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:23:24 -0400
Date: Wed, 24 Sep 2014 10:23:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Anders Berg <anders.berg@avagotech.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org
Subject: Re: [PATCH v2] spi: pl022: Add support for chip select extension
Message-ID: <20140924092312.GS5182@n2100.arm.linux.org.uk>
References: <20140916183431.GX7960@sirena.org.uk> <1410936418-26443-1-git-send-email-anders.berg@avagotech.com> <20140924083205.GZ4015@sirena.org.uk> <20140924083331.GA4015@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924083331.GA4015@sirena.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 09:33:31AM +0100, Mark Brown wrote:
> On Wed, Sep 24, 2014 at 09:32:05AM +0100, Mark Brown wrote:
> > On Wed, Sep 17, 2014 at 08:46:58AM +0200, Anders Berg wrote:
> > > Add support for a extended PL022 which has an extra register for controlling up
> > > to five chip select signals. This controller is found on the AXM5516 SoC.
> > > Unfortunately the PrimeCell identification registers are identical to a
> > > standard ARM PL022. To work around this, the peripheral ID must be overridden
> > > in the device tree using the "arm,primecell-periphid" property with the value
> > > 0x000b6022.
> > 
> > Applied, thanks.
> 
> Actually there's still the amba/bus.h update in here - I'll hold off for
> a while yet so Russell has a chance to review.

It's fine.  I'd prefer to have seen the vendor list ordered in some way
(since it's neither alphabetical nor numerical with its existing three
entries) but that would be the subject of a separate patch.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.

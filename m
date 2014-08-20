Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaHTJg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:36:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43669 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866AbaHTJg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:36:27 -0400
Date: Wed, 20 Aug 2014 10:36:21 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "atull@opensource.altera.com" <atull@opensource.altera.com>
Cc: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "baruch@tkos.co.il" <baruch@tkos.co.il>,
        "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "skuribay@pobox.com" <skuribay@pobox.com>,
        "Romain.Baeriswyl@abilis.com" <Romain.Baeriswyl@abilis.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "delicious.quinoa@gmail.com" <delicious.quinoa@gmail.com>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "yvanderv@opensource.altera.com" <yvanderv@opensource.altera.com>
Subject: Re: [PATCH 1/2] i2c: designware: device tree bindings for i2c speed
 mode
Message-ID: <20140820093621.GC21174@leverpostej>
References: <1408473276-10847-1-git-send-email-atull@opensource.altera.com>
 <20140820093459.GB21174@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820093459.GB21174@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 10:34:59AM +0100, Mark Rutland wrote:
> On Tue, Aug 19, 2014 at 07:34:35PM +0100, atull@opensource.altera.com wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> > 
> > Add "speed-mode" Device Tree property to select between
> > standard and fast i2c mode.  Previously, driver was hardwired
> > as fast mode.  Default to fast mode if property is not
> > present.
> > 
> > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > ---
> >  .../devicetree/bindings/i2c/i2c-designware.txt     |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/i2c/i2c-designware.txt b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> > index 5199b0c..0e4cd21 100644
> > --- a/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> > +++ b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> > @@ -9,6 +9,8 @@ Required properties :
> >  Recommended properties :
> >  
> >   - clock-frequency : desired I2C bus clock frequency in Hz.
> > + - speed-mode      : 0 = standard (0 - 100Kb/s)
> > +                   : 1 = fast (<= 400Kb/s) <== default
> 
> This is a bit opaque.
> 
> Is this a limit on the max bit-rate the device should operate at?
> 
> Why not just have an optional boolean property to limit to standard
> speed?

I see there's a new patch doing this based on clock-frequency, so feel
free to ignore this.

Mark.

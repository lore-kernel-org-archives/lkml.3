Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab3JXOuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 10:50:14 -0400
Received: from mail1.ams.com ([212.166.112.31]:29373 "EHLO mail1.ams.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605Ab3JXOuK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 10:50:10 -0400
X-Greylist: delayed 3055 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Oct 2013 10:50:09 EDT
X-IronPort-AV: E=Sophos;i="4.93,562,1378850400"; 
   d="scan'208";a="5589063"
From: Jon Brenner <Jon.Brenner@ams.com>
To: Sebastian Reichel <sre@debian.org>, Jonathan Cameron <jic23@kernel.org>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Jonathan Cameron <jic23@cam.ac.uk>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 24 Oct 2013 15:58:54 +0200
Subject: RE: [PATCH] iio:light:tsl2563: Add DT support
Thread-Topic: [PATCH] iio:light:tsl2563: Add DT support
Thread-Index: Ac7QvviVOO2Kzi5lSjuevOHNrYwP2QAAiKRg
Message-ID: <3C879D35B299F147B1DEDFBEE12F2E06012E5631C1@SUX2182.office.amsiag.com>
References: <1382565063-17083-1-git-send-email-sre@debian.org>
 <5268DA76.6060503@kernel.org> <20131024134259.GB3681@earth.universe>
In-Reply-To: <20131024134259.GB3681@earth.universe>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMS-TAOS

-----Original Message-----
From: Sebastian Reichel [mailto:sre@debian.org] 
Sent: Thursday, October 24, 2013 8:43 AM
To: Jonathan Cameron
Cc: linux-iio@vger.kernel.org; Rob Herring; Pawel Moll; Mark Rutland; Stephen Warren; Ian Campbell; Rob Landley; Jonathan Cameron; Peter Meerwald; Greg Kroah-Hartman; Bill Pemberton; Sachin Kamat; devicetree@vger.kernel.org; linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org; Jon Brenner
Subject: Re: [PATCH] iio:light:tsl2563: Add DT support

On Thu, Oct 24, 2013 at 09:29:42AM +0100, Jonathan Cameron wrote:
> On 10/23/13 22:51, Sebastian Reichel wrote:
> > Add Device Tree support for the TSL2563 driver and document the 
> > binding.
> > 
> > Signed-off-by: Sebastian Reichel <sre@debian.org>
> > ---
> >  .../devicetree/bindings/iio/light/tsl2563.txt         | 19 +++++++++++++++++++
> >  drivers/iio/light/tsl2563.c                           |  4 ++++
> >  2 files changed, 23 insertions(+)
> >  create mode 100644 
> > Documentation/devicetree/bindings/iio/light/tsl2563.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/iio/light/tsl2563.txt 
> > b/Documentation/devicetree/bindings/iio/light/tsl2563.txt
> > new file mode 100644
> > index 0000000..b52cf4b
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/iio/light/tsl2563.txt
> > @@ -0,0 +1,19 @@
> > +* TAOS TSL2563 ambient light sensor
> > +
> > +Required properties:
> > +
> > +  - compatible : should be "taos,tsl2563"
> > +  - reg : the I2C address of the sensor
> > +
> > +Optional properties:
> > +
> So two options for this one.  Either pitch it as a possible general 
> parameter, or mark it with a vendor prefix.  It seems like something 
> fairly general, but in that case it probably needs a more detailed proposal and explanation of exactly what it is.

OK, I will add a vendor prefix in a PATCHv2. When I converted the driver to DT I had a look how this is used and I don't think it's "fairly general".

> Also, is taos listed in vendor-prefixes.txt?  Jon, is that the right vendor prefix to use?
> I'm guessing you have some non mainline bindings out there already so 
> it would be good to match those...

taos is currently not listed in the vendor-prefixes.txt file. Also it seems that "TAOS Inc." has been absorbed by "ams AG" in 2011.
So how to proceed with the patch?

-- Sebastian

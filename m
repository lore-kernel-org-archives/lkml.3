Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935638Ab3BTNtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:49:31 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53384 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935340Ab3BTNt3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:49:29 -0500
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "liam.r.girdwood@intel.com" <liam.r.girdwood@intel.com>
Subject: RE: [PATCH 1/4] documentation: add palmas dts definition
Thread-Topic: [PATCH 1/4] documentation: add palmas dts definition
Thread-Index: AQHODx7rXccjEGg3CE6BVl49YkJwT5iCP9wAgACBM1A=
Date: Wed, 20 Feb 2013 13:49:09 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229BBE34@DBDE01.ent.ti.com>
References: <1361332815-2348-1-git-send-email-j-keerthy@ti.com>
 <20130220112639.GA2726@opensource.wolfsonmicro.com>
In-Reply-To: <20130220112639.GA2726@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Wednesday, February 20, 2013 4:57 PM
> To: J, KEERTHY
> Cc: devicetree-discuss@lists.ozlabs.org; linux-doc@vger.kernel.org;
> linux-kernel@vger.kernel.org; grant.likely@secretlab.ca;
> rob.herring@calxeda.com; rob@landley.net; gg@slimlogic.co.uk;
> sameo@linux.intel.com; liam.r.girdwood@intel.com
> Subject: Re: [PATCH 1/4] documentation: add palmas dts definition
> 
> On Wed, Feb 20, 2013 at 09:30:15AM +0530, J Keerthy wrote:
> > From: Graeme Gregory <gg@slimlogic.co.uk>
> >
> > Add the DTS definition for the palmas device including the MFD
> children.
> >
> > Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> > [j-keerthy@ti.com: changed the DT node property names to follow the
> > convention]
> > Signed-off-by: J Keerthy <j-keerthy@ti.com>
> > ---
> >  Documentation/devicetree/bindings/mfd/palmas.txt |   67
> ++++++++++++++++++++++
> >  1 files changed, 67 insertions(+), 0 deletions(-)  create mode
> 100644
> > Documentation/devicetree/bindings/mfd/palmas.txt
> >
> > diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt
> > b/Documentation/devicetree/bindings/mfd/palmas.txt
> > new file mode 100644
> > index 0000000..5fa922e
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mfd/palmas.txt
> > @@ -0,0 +1,67 @@
> > +Texas Instruments Palmas family
> > +
> > +The Palmas familly are Integrated Power Management Chips.
> > +These chips are connected to an i2c bus.
> 
> I would expect this to enumerate the regulators that the user can
> select but it doesn't appear to do that.


Mark,

Thanks for reviewing the patch.

I went through the DT Documentation files in the regulator/ folder.
So shall I add a list of regulators which are in the Palmas device
Under a separate file under Documentation/devicetree/bindings/regulator ?
Is that what you are looking for?

Regards,
Keerthy


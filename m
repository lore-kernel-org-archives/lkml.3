Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab3AVJbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:31:42 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60617 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab3AVJbi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:31:38 -0500
From: "Patil, Rachna" <rachna@ti.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Rob Herring <rob.herring@calxeda.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, Tony Lindgren <tony@atomide.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
Subject: RE: [PATCH v3 4/8] MFD: ti_am335x_tscadc: add device tree binding
 information
Thread-Topic: [PATCH v3 4/8] MFD: ti_am335x_tscadc: add device tree binding
 information
Thread-Index: AQHN9WaR+kL8mfzmW0W9KVD31i8nTZhQ4YkAgAQ5TSA=
Date: Tue, 22 Jan 2013 09:31:02 +0000
Message-ID: <4CE347531D4CA947960AF71FF095B9323E9AFB02@DBDE01.ent.ti.com>
References: <cover.1358502134.git.rachna@ti.com>
 <daf18b4779ac3c6b69b1e7e2d1a4abd18b13fee5.1358502134.git.rachna@ti.com>
 <50FB1DFE.6090805@metafoo.de>
In-Reply-To: <50FB1DFE.6090805@metafoo.de>
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

Hi,

On Sun, Jan 20, 2013 at 03:58:14, Lars-Peter Clausen wrote:
> Hi,
> 
> On 01/18/2013 11:48 AM, Patil, Rachna wrote:
> > From: "Patil, Rachna" <rachna@ti.com>
> > 
> > Signed-off-by: Patil, Rachna <rachna@ti.com>
> > ---
> >  .../devicetree/bindings/mfd/ti_am335x_tscadc.txt   |   35 ++++++++++++++++++++
> >  1 file changed, 35 insertions(+)
> >  create mode 100644 
> > Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt
> > 
> > diff --git 
> > a/Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt 
> > b/Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt
> > new file mode 100644
> > index 0000000..c13c492
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt
> > @@ -0,0 +1,35 @@
> > +Texas Instruments - TSC / ADC multi-functional device
> > +
> > +ti_tscadc is a multi-function device with touchscreen and ADC on chip.
> > +This document describes the binding for mfd device.
> > +
> > +Required properties:
> > +- compatible: "ti,ti-tscadc"
> > +- reg: Specifies the address of MFD block
> > +- interrupts: IRQ line connected to the main SoC
> > +- interrupt-parent: The parent interrupt controller
> 
> The subnodes and their properties also need documentation.

Ok. I Will add this.

> 
> > +
> > +Optional properties:
> > +- ti,hwmods: Hardware information related to TSC/ADC MFD device
> > +
> > +Example:
> > +
> > +	tscadc: tscadc@44e0d000 {
> > +		compatible = "ti,ti-tscadc";
> > +		reg = <0x44e0d000 0x1000>;
> > +
> > +		interrupt-parent = <&intc>;
> > +		interrupts = <16>;
> > +		ti,hwmods = "adc_tsc";
> > +
> > +		tsc {
> > +			wires = <4>;
> > +			x-plate-resistance = <200>;
> > +			steps-to-configure = <5>;
> > +			wire-config = <0x00 0x11 0x22 0x33>;
> 
> Non-standard properties should have a vendor prefix.

Ok. I will fix this in the next version of the patch set.

Regards,
Rachna


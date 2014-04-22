Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaDVBh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:37:56 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:3583 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaDVBhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:37:53 -0400
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] ARM: dts: at91-sama5d3_xplained: add the regulator
 device node
Thread-Topic: [PATCH] ARM: dts: at91-sama5d3_xplained: add the regulator
 device node
Thread-Index: AQHPXRswrA2f1ffIY0GWPrJ4xJGUOJsbTx2AgAApLYCAAWLlUA==
Date: Tue, 22 Apr 2014 01:37:15 +0000
Message-ID: <B256D81BAE5131468A838E5D7A24364180A876DA@penmbx01>
References: <1398054547-5834-1-git-send-email-wenyou.yang@atmel.com>
 <20140421095443.GA3461@piout.net> <20140421122205.GB3461@piout.net>
In-Reply-To: <20140421122205.GB3461@piout.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Alexandre Belloni [mailto:alexandre.belloni@free-electrons.com]
> Sent: Monday, April 21, 2014 8:22 PM
> To: Yang, Wenyou
> Cc: devicetree@vger.kernel.org; Ferre, Nicolas; linux-
> kernel@vger.kernel.org; robh+dt@kernel.org; broonie@kernel.org; linux-
> arm-kernel@lists.infradead.org
> Subject: Re: [PATCH] ARM: dts: at91-sama5d3_xplained: add the regulator
> device node
> 
> On 21/04/2014 at 11:54:43 +0200, Alexandre Belloni wrote :
> > Hi,
> >
> > On 21/04/2014 at 12:29:07 +0800, Wenyou Yang wrote :
> > > +
> > > +						vddana_reg: LDO_REG2 {
> > > +							regulator-name = "VDDANA";
> > > +							regulator-min-microvolt =
> <3300000>;
> > > +							regulator-max-microvolt =
> <3300000>;
> > > +							regulator-always-on;
> >
> > I'm pretty sure that one is not always on as you actually have to
> > configure it to get any voltage. Are you sure you want to set the
> > regulator-always-on property here ?
> >
> 
> Just to clarify my though, wouldn't it be better to make the ADC driver
> handle that regulator instead of using regulator-always-on ?
Yes, you are right. 
It should not use regulator-always-on property for this regulator. It is ADC driver and ISI driver to handle it(The ISI takes PCK for clock).

I will send new version patch.

Thanks

> 
> --
> Alexandre Belloni, Free Electrons
> Embedded Linux, Kernel and Android engineering http://free-
> electrons.com

Best Regards,
Wenyou Yang

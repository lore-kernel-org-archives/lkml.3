Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbaDHOYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:24:04 -0400
Received: from mail-by2on0137.outbound.protection.outlook.com ([207.46.100.137]:30784
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756713AbaDHOYA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:24:00 -0400
Message-ID: <1396967390.23349.15.camel@dinh-ubuntu>
Subject: Re: [PATCH 1/3] dts: socfpga: Add bindings for Altera SoC SDRAM
 controller
From: Thor Thayer <tthayer@altera.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: <robherring2@gmail.com>, <dougthompson@xmission.com>,
        <grant.likely@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <dinguyen@altera.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-doc@vger.kernel.org>
Date: Tue, 8 Apr 2014 09:29:50 -0500
In-Reply-To: <20140408133818.GB16054@pengutronix.de>
References: <1396907649-20212-1-git-send-email-tthayer@altera.com>
	 <1396907649-20212-2-git-send-email-tthayer@altera.com>
	 <20140408133818.GB16054@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: =?utf-8?B?Q0lQOjY2LjM1LjIzNi4yMzI7Q1RSWTpVUztJUFY6TkxJO0VGVjpOTEk7U0ZW?=
 =?utf-8?B?Ok5TUE07U0ZTOigxMDAxOTAwMSkoNjAwOTAwMSkoNDU4MDAxKSgzNzc0MjQw?=
 =?utf-8?B?MDQpKDUxNDQ0MDAzKSg1MTcwNDAwNSkoMTk5MDAyKSgxODkwMDIpKDI0NDU0?=
 =?utf-8?B?MDAyKSgyMzY3NjAwMikoODE1NDIwMDEpKDE5NTgwMzk1MDAzKSg0NzQ0NjAw?=
 =?utf-8?B?MikoNzY3ODYwMDEpKDMzNjQ2MDAxKSg2Mjk2NjAwMikoNTY4MTYwMDUpKDk1?=
 =?utf-8?B?NjY2MDAzKSg5MzkxNjAwMikoNDM5NjAwMSkoODE4MTYwMDEpKDMzNzE2MDAx?=
 =?utf-8?B?KSg5OTM5NjAwMikoODQ2NzYwMDEpKDIwMDkwMDEpKDQ0OTc2MDA1KSg0Nzc3?=
 =?utf-8?B?NjAwMykoMTk1ODA0MDUwMDEpKDUwMjI2MDAxKSg5MDE0NjAwMSkoNzY0ODIw?=
 =?utf-8?B?MDEpKDc0MzY2MDAxKSg4MzMyMjAwMSkoODc5MzYwMDEpKDQ5ODY2MDAxKSg3?=
 =?utf-8?B?Nzk4MjAwMSkoMTY3OTYwMDIpKDk3MTg2MDAxKSgzMTk2NjAwOCkoNTA0NjYw?=
 =?utf-8?B?MDIpKDg1MzA2MDAyKSg3NzE1NjAwMSkoODgxMzYwMDIpKDk3MzM2MDAxKSg4?=
 =?utf-8?B?MTY4NjAwMSkoOTg2NzYwMDEpKDIwNzc2MDAzKSg1NDMxNjAwMikoNzQ4NzYw?=
 =?utf-8?B?MDEpKDc5MTAyMDAxKSg2MzY5NjAwMikoOTI3MjYwMDEpKDY1ODE2MDAxKSg4?=
 =?utf-8?B?MTM0MjAwMSkoNjkyMjYwMDEpKDkyNTY2MDAxKSg4MDk3NjAwMSkoNDYxMDIw?=
 =?utf-8?B?MDEpKDc0NzA2MDAxKSg4MzA3MjAwMikoNDc3MzYwMDEpKDg1ODUyMDAzKSg1?=
 =?utf-8?B?MzgwNjAwMSkoNTY3NzYwMDEpKDc3MDk2MDAxKSg5NDk0NjAwMSkoNjgwNjAw?=
 =?utf-8?B?NCkoOTc3MzYwMDEpKDkzNTE2MDAyKSg4NjM2MjAwMSkoNTk3NjYwMDEpKDc0?=
 =?utf-8?B?NTAyMDAxKSg4NzI4NjAwMSkoODk5OTYwMDEpKDc2Nzk2MDAxKSg4MDAyMjAw?=
 =?utf-8?B?MSkoNDc5NzYwMDEpKDk0MzE2MDAyKSg1MDk4NjAwMSkoNzQ2NjIwMDEpKDk1?=
 =?utf-8?B?NDE2MDAxKSg4NzI2NjAwMSkoOTMxMzYwMDEpKDQyMTg2MDA0KTtESVI6T1VU?=
 =?utf-8?B?O1NGUDoxMTAyO1NDTDoxO1NSVlI6Qk4xQkZGTzExSFVCMDU0O0g6U0otSVRF?=
 =?utf-8?B?WEVER0UwMi5hbHRlcmEucHJpdi5hbHRlcmEuY29tO0ZQUjo2MkM1Rjc2MS5B?=
 =?utf-8?B?QjJBREJFOC5GQ0Q0MkQxMy40QURBRTMzMS4yMDJEMTtNTFY6c2Z2O1BUUjpJ?=
 =?utf-8?Q?nfoDomainNonexistent;A:1;MX:1;LANG:en;?=
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 017589626D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-08 at 15:38 +0200, Steffen Trumtrar wrote:
> Hi!
> 
> On Mon, Apr 07, 2014 at 04:54:07PM -0500, tthayer@altera.com wrote:
> > From: Thor Thayer <tthayer@altera.com>
> > 
> > Addition of the Altera SDRAM controller bindings and device
> > tree changes to the Altera SoC project.
> > 
[snip]
> > +
> > +Required properties:
> > +- compatible : "altr,sdr-ctl", "syscon";
> > +                Note that syscon is invoked for this device to support the FPGA
> > +		bridge driver, EDAC driver and other devices that share the
> > +		registers.
> > +- reg : Should contain 1 register ranges(address and length)
> 
> I haven't really thought this through, but why would the FPGA bridge driver
> access the sdram controller? For releasing the resets in fpgaportrst ? Or is
> there more?

Hi Steffan. No, not for resets. We need to enable the FPGA to SDRAM
path. Our SDRAM controller allows FPGA master access to the SDRAM.

> Wouldn't it be more appropriate to represent those bits as a reset-controller to
> some hypothetical IP core driver?
> Then you could have something like
> 
> 	hps2fpga@c0000000 {
> 		ipcore@0 {
> 			resets = <&sdr 1>;
> 			reset-names = "foo";
> 			resets = <&rst 96>;
> 			reset-names = "bar";
> 			(...)
> 		};
> 
> 		ipcore@1000 {
> 			resets = <&rst 96>;
> 			reset-names = "baz";
> 			(...)
> 		};
> 	};
> 
> And you would always have the correct bridges released out of reset for your
> IP core. Does the FPGA bridge driver do more? I think that is basically it.
> Where we maybe could run into problems though is the early_init stuff.
> 
> I think syscon is nice for some things, but we should try not to overuse it.

Understood. In this case, syscon seems to be appropriate.
> 
> Regards,
> Steffen
> 
> > +Example:
> > +	sdrctl@ffc25000 {
> > +		compatible = "altr,sdr-ctl", "syscon";
> > +		reg = <0xffc25000 0x1000>;
> > +	};
> > diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
> > index df43702..6ce912e 100644
> > --- a/arch/arm/boot/dts/socfpga.dtsi
> > +++ b/arch/arm/boot/dts/socfpga.dtsi
> > @@ -676,6 +676,11 @@
> >  			clocks = <&l4_sp_clk>;
> >  		};
> >  
> > +		sdrctl@ffc25000 {
> > +			compatible = "altr,sdr-ctl", "syscon";
> > +			reg = <0xffc25000 0x1000>;
> > +		};
> > +
> >  		rstmgr@ffd05000 {
> >  			compatible = "altr,rst-mgr";
> >  			reg = <0xffd05000 0x1000>;
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbaDBSNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 14:13:50 -0400
Received: from [65.55.169.134] ([65.55.169.134]:56239 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932517AbaDBSNq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 14:13:46 -0400
X-Greylist: delayed 158054 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2014 14:13:46 EDT
Message-ID: <1396462621.3854.8.camel@dinh-ubuntu>
Subject: Re: [PATCH 1/2] dts: socfpga: Add bindings for Altera SoC SDRAM
 controller
From: Thor Thayer - Sendmail <tthayer@altera.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <pawel.moll@arm.com>,
        <linux-doc@vger.kernel.org>, <devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <rob.herring@calxeda.com>,
        <linux-arm-kernel@lists.infradead.org>, <rob@landley.net>,
        <galak@codeaurora.org>, <dinguyen@altera.com>
Date: Wed, 2 Apr 2014 13:17:01 -0500
In-Reply-To: <20140401221913.GR5052@pengutronix.de>
References: <1396303627-29198-1-git-send-email-tthayer@altera.com>
	 <1396303627-29198-2-git-send-email-tthayer@altera.com>
	 <20140401052807.GN5052@pengutronix.de>
	 <1396383101.20336.6.camel@dinh-ubuntu>
	 <20140401221913.GR5052@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: =?utf-8?B?Q0lQOjY2LjM1LjIzNi4yMzI7Q1RSWTpVUztJUFY6TkxJO0VGVjpOTEk7U0ZW?=
 =?utf-8?B?Ok5TUE07U0ZTOigxMDAxOTAwMSkoOTc5MDAyKSg2MDA5MDAxKSg0NTgwMDEp?=
 =?utf-8?B?KDM3NzQyNDAwNCkoNTE5MTQwMDMpKDQxNTc0MDAyKSgyNDQ1NDAwMikoNTE3?=
 =?utf-8?B?MDQwMDUpKDE4OTAwMikoNjkyMzQwMDUpKDE5OTAwMikoODEzNDIwMDEpKDgw?=
 =?utf-8?B?MDIyMDAxKSg0OTg2NjAwMSkoODA5NzYwMDEpKDQzOTYwMDEpKDQ0OTc2MDA1?=
 =?utf-8?B?KSgyMDA5MDAxKSg5NTQxNjAwMSkoODk5OTYwMDEpKDMxOTY2MDA4KSg4NDY3?=
 =?utf-8?B?NjAwMSkoNjI5NjYwMDIpKDUwMjI2MDAxKSg5MjU2NjAwMSkoMzM3MTYwMDEp?=
 =?utf-8?B?KDk3MTg2MDAxKSg4ODEzNjAwMikoNDc3MzYwMDEpKDUwNDY2MDAyKSg3NDM2?=
 =?utf-8?B?NjAwMSkoOTQzMTYwMDIpKDk3NzM2MDAxKSgyMzY3NjAwMikoOTQ5NDYwMDEp?=
 =?utf-8?B?KDg2MzYyMDAxKSg5MzkxNjAwMikoOTMxMzYwMDEpKDg3Mjg2MDAxKSg5MzUx?=
 =?utf-8?B?NjAwMikoOTczMzYwMDEpKDk5Mzk2MDAyKSg4NzI2NjAwMSkoNjkyMjYwMDEp?=
 =?utf-8?B?KDk1NjY2MDAzKSg3NDY2MjAwMSkoOTg2NzYwMDEpKDkwMTQ2MDAxKSg4NTg1?=
 =?utf-8?B?MjAwMykoODE1NDIwMDEpKDgxNjg2MDAxKSg3Nzk4MjAwMSkoNDc5NzYwMDEp?=
 =?utf-8?B?KDY4MDYwMDQpKDMzNjQ2MDAxKSg3NDcwNjAwMSkoNzY0ODIwMDEpKDgxODE2?=
 =?utf-8?B?MDAxKSg3Njc4NjAwMSkoNDYxMDIwMDEpKDQyMTg2MDA0KSg2MzY5NjAwMiko?=
 =?utf-8?B?ODMwNzIwMDIpKDU2Nzc2MDAxKSgxOTU4MDQwNTAwMSkoODMzMjIwMDEpKDc3?=
 =?utf-8?B?MTU2MDAxKSg3NzA5NjAwMSkoODUzMDYwMDIpKDE2Nzk2MDAyKSg3NDUwMjAw?=
 =?utf-8?B?MSkoNTY4MTYwMDUpKDY1ODE2MDAxKSg3NDg3NjAwMSkoNTA5ODYwMDEpKDQ3?=
 =?utf-8?B?Nzc2MDAzKSg4NzkzNjAwMSkoOTI3MjYwMDEpKDQ3NDQ2MDAyKSgyMDc3NjAw?=
 =?utf-8?B?MykoNTk3NjYwMDEpKDU0MzE2MDAyKSg3Njc5NjAwMSkoNTE4NTYwMDEpKDUz?=
 =?utf-8?B?ODA2MDAxKSg3OTEwMjAwMSkoMTk1ODAzOTUwMDMpKDk5MTA2MDAxKSg5Njkw?=
 =?utf-8?B?MDMpKDk4OTAwMSkoOTk5MDAxKSgxMDA5MDAxKSgxMDE5MDAxKTtESVI6T1VU?=
 =?utf-8?B?O1NGUDoxMTAyO1NDTDoxO1NSVlI6QkwyRkZPMTFIVUIwMzI7SDpTSi1JVEVY?=
 =?utf-8?B?RURHRTAyLmFsdGVyYS5wcml2LmFsdGVyYS5jb207RlBSOkEzRTFGMDlFLkE3?=
 =?utf-8?B?RjBCMUE1LkZGQzU1RUFCLjg4RDZDMjM4LjIwMzgyO01MVjpvdnJuc3BtO1BU?=
 =?utf-8?Q?R:InfoDomainNonexistent;MX:1;A:1;LANG:en;?=
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0169092318
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-02 at 00:19 +0200, Steffen Trumtrar wrote:
> Hi!
> 
> On Tue, Apr 01, 2014 at 03:11:41PM -0500, Thor Thayer - Sendmail wrote:
> > On Tue, 2014-04-01 at 07:28 +0200, Steffen Trumtrar wrote:
> > > Hi!
> > > 
> > > On Mon, Mar 31, 2014 at 05:07:06PM -0500, tthayer@altera.com wrote:
> > > > From: Thor Thayer <tthayer@altera.com>
> > > > 
> > > > Addition of the Altera SDRAM controller bindings and device
> > > > tree changes to the Altera SoC project.
> > > >
> > 
> > <snip>
> > 
> > > > diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> > > > new file mode 100644
> > > > index 0000000..351ab7b
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> > > > @@ -0,0 +1,14 @@
> > > > +Altera SOCFPGA SDRAM Controller
> > > > +
> > > > +Required properties:
> > > > +- compatible : "altr,sdr-ctl", "syscon";
> > > > +                Note that syscon is invoked for this device to support the FPGA
> > > > +		bridge driver and possibly other devices in the future.  See
> > > > +		also Documentation/devicetree/bindings/mfd/syscon.txt
> > > 
> > > This note is really linux specific (and specific to some vendor kernel driver
> > > for that matter). I think you should remove that.
> > 
> > Hi Steffen. Are you asking for the path to syscon.txt to be removed or
> > the entire note? 
> > The note is explaining why the "syscon" tag is used for this Altera IP
> > block (registers shared between multiple drivers).
> > Thanks for the clarification.
> > 
> 
> I was referring to the note. I don't know what the current guideline is for
> this type of "devices", but I think referring to the syscon documentation
> is okay.
> The first part however describes a DT binding with things that might or might
> not happen in the future. What I want to say is, I would rather have this
> reworded, to have it just describe the SDRAM controller node as simple as it may
> be.

I see the confusion. It was not written well. I'll abandon this patch. 

I have another patch series ready that uses the "syscon" parameter of
the SDRAM controller so I'll include this patch in that series. The need
for the "syscon" will be more apparent. Thanks!
> 
> > > 
> > > > +- reg : Should contain 1 register ranges(address and length)
> > > > +
> > > > +Example:
> > > > +	sdrctl@0xffc25000 {
> > > > +		compatible = "altr,sdr-ctl", "syscon";
> > > > +		reg = <0xffc25000 0x1000>;
> > > > +	};
> > > > diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
> > > > index 9e78c1d..3634de7 100644
> > > > --- a/arch/arm/boot/dts/socfpga.dtsi
> > > > +++ b/arch/arm/boot/dts/socfpga.dtsi
> > > > @@ -528,6 +528,11 @@
> > > >  			reg-io-width = <4>;
> > > >  		};
> > > >  
> > > > +		sdrctl@0xffc25000 {
>                        ^^
> Oh, and Dinh just mentioned in my patch, that the 0x shall be removed here.
> But I'm not so sure about that. Just FYI.
> 
Thanks.
> > > > +			compatible = "altr,sdr-ctl", "syscon";
> > > > +			reg = <0xffc25000 0x1000>;
> > > > +		};
> > > > +
> > > >  		rstmgr@ffd05000 {
> > > >  			compatible = "altr,rst-mgr";
> > > >  			reg = <0xffd05000 0x1000>;
> 
> Regards,
> Steffen
> 



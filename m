Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbaDAUGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:06:53 -0400
Received: from [207.46.100.133] ([207.46.100.133]:24767 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751354AbaDAUGu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:06:50 -0400
X-Greylist: delayed 79353 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Apr 2014 16:06:49 EDT
Message-ID: <1396383101.20336.6.camel@dinh-ubuntu>
Subject: Re: [PATCH 1/2] dts: socfpga: Add bindings for Altera SoC SDRAM
 controller
From: Thor Thayer - Sendmail <tthayer@altera.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: <dinguyen@altera.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>
Date: Tue, 1 Apr 2014 15:11:41 -0500
In-Reply-To: <20140401052807.GN5052@pengutronix.de>
References: <1396303627-29198-1-git-send-email-tthayer@altera.com>
	 <1396303627-29198-2-git-send-email-tthayer@altera.com>
	 <20140401052807.GN5052@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: =?utf-8?B?Q0lQOjY2LjM1LjIzNi4yMzI7Q1RSWTpVUztJUFY6TkxJO0VGVjpOTEk7U0ZW?=
 =?utf-8?B?Ok5TUE07U0ZTOigxMDAxOTAwMSkoNjAwOTAwMSkoNDU4MDAxKSgxOTkwMDIp?=
 =?utf-8?B?KDUxOTE0MDAzKSgyNDQ1NDAwMikoMTg5MDAyKSg1MTcwNDAwNSkoMzc3NDI0?=
 =?utf-8?B?MDA0KSg4MTM0MjAwMSkoNzcwOTYwMDEpKDc2NDgyMDAxKSg2Mjk2NjAwMiko?=
 =?utf-8?B?MzM3MTYwMDEpKDc0NTAyMDAxKSgzMzY0NjAwMSkoOTI3MjYwMDEpKDE2Nzk2?=
 =?utf-8?B?MDAyKSg2MzY5NjAwMikoNDYxMDIwMDEpKDMxOTY2MDA4KSg3NDY2MjAwMSko?=
 =?utf-8?B?NTE4NTYwMDEpKDc0NzA2MDAxKSg4MTU0MjAwMSkoNDc0NDYwMDIpKDQyMTg2?=
 =?utf-8?B?MDA0KSg1MDQ2NjAwMikoNTk3NjYwMDEpKDUzODA2MDAxKSg3NDg3NjAwMSko?=
 =?utf-8?B?NzY3ODYwMDEpKDg3MjY2MDAxKSg5MzUxNjAwMikoODc5MzYwMDEpKDkzMTM2?=
 =?utf-8?B?MDAxKSg3OTEwMjAwMSkoODcyODYwMDEpKDU0MzE2MDAyKSg3NDM2NjAwMSko?=
 =?utf-8?B?NDM5NjAwMSkoMjM2NzYwMDIpKDk3MzM2MDAxKSg4MDAyMjAwMSkoNzc5ODIw?=
 =?utf-8?B?MDEpKDY5MjI2MDAxKSg1MDIyNjAwMSkoOTcxODYwMDEpKDk1NDE2MDAxKSg4?=
 =?utf-8?B?ODEzNjAwMikoOTc3MzYwMDEpKDQ0OTc2MDA1KSgxOTU4MDM5NTAwMykoODQ2?=
 =?utf-8?B?NzYwMDEpKDgxODE2MDAxKSg4MTY4NjAwMSkoNjU4MTYwMDEpKDgzMDcyMDAy?=
 =?utf-8?B?KSg1NjgxNjAwNSkoODUzMDYwMDIpKDk0OTQ2MDAxKSg0OTg2NjAwMSkoODYz?=
 =?utf-8?B?NjIwMDEpKDc2Nzk2MDAxKSg5ODY3NjAwMSkoNTY3NzYwMDEpKDg1ODUyMDAz?=
 =?utf-8?B?KSg0Nzk3NjAwMSkoNTA5ODYwMDEpKDk0MzE2MDAyKSg2ODA2MDA0KSg5Mzkx?=
 =?utf-8?B?NjAwMikoODA5NzYwMDEpKDkyNTY2MDAxKSg5NTY2NjAwMykoMjAwOTAwMSko?=
 =?utf-8?B?OTAxNDYwMDEpKDgzMzIyMDAxKSgxOTU4MDQwNTAwMSkoNzcxNTYwMDEpKDg5?=
 =?utf-8?B?OTk2MDAxKSgyMDc3NjAwMykoNDc3MzYwMDEpKDQ3Nzc2MDAzKSg5OTM5NjAw?=
 =?utf-8?B?Mik7RElSOk9VVDtTRlA6MTEwMjtTQ0w6MTtTUlZSOkJOMUJGRk8xMUhVQjA1?=
 =?utf-8?B?MztIOlNKLUlURVhFREdFMDIuYWx0ZXJhLnByaXYuYWx0ZXJhLmNvbTtGUFI6?=
 =?utf-8?B?RTNGMkY0MUUuQUYzMEEyMjUuQ0ZENzdGOTMuODhENkMyMzguMjAyNkQ7TUxW?=
 =?utf-8?B?OnNmdjtQVFI6SW5mb0RvbWFpbk5vbmV4aXN0ZW50O0E6MTtNWDoxO0xBTkc6?=
 =?utf-8?Q?en;?=
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 016885DD9B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 07:28 +0200, Steffen Trumtrar wrote:
> Hi!
> 
> On Mon, Mar 31, 2014 at 05:07:06PM -0500, tthayer@altera.com wrote:
> > From: Thor Thayer <tthayer@altera.com>
> > 
> > Addition of the Altera SDRAM controller bindings and device
> > tree changes to the Altera SoC project.
> >

<snip>

> > diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> > new file mode 100644
> > index 0000000..351ab7b
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> > @@ -0,0 +1,14 @@
> > +Altera SOCFPGA SDRAM Controller
> > +
> > +Required properties:
> > +- compatible : "altr,sdr-ctl", "syscon";
> > +                Note that syscon is invoked for this device to support the FPGA
> > +		bridge driver and possibly other devices in the future.  See
> > +		also Documentation/devicetree/bindings/mfd/syscon.txt
> 
> This note is really linux specific (and specific to some vendor kernel driver
> for that matter). I think you should remove that.

Hi Steffen. Are you asking for the path to syscon.txt to be removed or
the entire note? 
The note is explaining why the "syscon" tag is used for this Altera IP
block (registers shared between multiple drivers).
Thanks for the clarification.

> 
> > +- reg : Should contain 1 register ranges(address and length)
> > +
> > +Example:
> > +	sdrctl@0xffc25000 {
> > +		compatible = "altr,sdr-ctl", "syscon";
> > +		reg = <0xffc25000 0x1000>;
> > +	};
> > diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
> > index 9e78c1d..3634de7 100644
> > --- a/arch/arm/boot/dts/socfpga.dtsi
> > +++ b/arch/arm/boot/dts/socfpga.dtsi
> > @@ -528,6 +528,11 @@
> >  			reg-io-width = <4>;
> >  		};
> >  
> > +		sdrctl@0xffc25000 {
> > +			compatible = "altr,sdr-ctl", "syscon";
> > +			reg = <0xffc25000 0x1000>;
> > +		};
> > +
> >  		rstmgr@ffd05000 {
> >  			compatible = "altr,rst-mgr";
> >  			reg = <0xffd05000 0x1000>;
> 
> Regards,
> Steffen
> 


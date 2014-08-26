Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbaHZK4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:56:38 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.162]:16026 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754369AbaHZK4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:56:34 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-8.tower-38.messagelabs.com!1409050500!24753774!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Andrew Lunn <andrew@lunn.ch>, Arnaud Ebalard <arno@natisbad.org>,
        "DEVICE TREE" <devicetree@vger.kernel.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        "Jason Gunthorpe" <jgunthorpe@obsidianresearch.com>,
        Jonathan Cameron <jic23@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        LINUX ARM KERNEL <linux-arm-kernel@lists.infradead.org>,
        LINUX KERNEL <linux-kernel@vger.kernel.org>,
        LINUX SH <linux-sh@vger.kernel.org>,
        "Magnus Damm" <magnus.damm@gmail.com>, Mark Brown <broonie@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin Fuzzey <mfuzzey@parkeon.com>, Pawel Moll <pawel.moll@arm.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Silvio F <silvio.fricke@gmail.com>, Simon Horman <horms@verge.net.au>,
        Support Opensource <Support.Opensource@diasemi.com>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: RE: [RESEND PATCH V2] devicetree: Dialog Semiconductor consolidate
 existing vendor prefixes to standardise on 'dlg'
Thread-Topic: [RESEND PATCH V2] devicetree: Dialog Semiconductor consolidate
 existing vendor prefixes to standardise on 'dlg'
Thread-Index: AQHPvhfch2EQAldnUU2QQdc1zxybRJvilI4AgAAg4zA=
Date: Tue, 26 Aug 2014 10:54:59 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7D0B39744@SW-EX-MBX02.diasemi.com>
References: <201408221446.s7MEkNVF001775@swsrvapps-01.diasemi.com>
 <20140826093312.GI9574@lee--X1>
In-Reply-To: <20140826093312.GI9574@lee--X1>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.77]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7QAufGq001383

On 26 August 2014 10:33 Lee Jones wrote:

> On Fri, 22 Aug 2014, Opensource [Steve Twiss] wrote:
> > From: Steve Twiss <stwiss.opensource@diasemi.com>
> >
> > This patch series updates the device tree vendor prefix for
> > Dialog Semiconductor.
> >

[...]

> > I think this is it. But, if I am missing anything or there are problems, can
> > I get a quick explanation in the reply so I can fix it and move forwards
> > please?
> >
> > In full:
> > Acked-by the following people so far:
> 
> When you say "so far", does that mean you're missing Acks still?

Hi Lee,

Apologies for my "so far" -- that is just my wording.

As I understand it I have all the Acks that are necessary. I am basing my Acks list on
the get_maintainers script output and on a previous request for Renesas and 
Freescale inputs -- which I have also got.
I do not see any mistakes or missing entries from my part.

> 
> If you have the full-set I will apply this and send out the necessary
> pull-request(s).
> 

Yes please.

Regards,
Steve

ps. for reference,  this is my justification for all files in the patch.

./drivers/mfd/da9055-core.c
	Support Opensource <support.opensource@diasemi.com> (supporter:DIALOG SEMICONDUC...)
	Lee Jones <lee.jones@linaro.org> (supporter:MULTIFUNCTION DEV...,commits:3/8=38%)

./Documentation/devicetree/bindings/regulator/da9210.txt.get_maintainer
	Rob Herring <robh+dt@kernel.org> (maintainer:OPEN FIRMWARE AND...)
	S Twiss <stwiss.opensource@diasemi.com> (authored lines:2/21=10%)

./arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi.get_maintainer
	Shawn Guo <shawn.guo@freescale.com> (maintainer:ARM/FREESCALE IMX...,authored lines:276/279=99%,commits:6/7=86%)
	Rob Herring <robh+dt@kernel.org> (maintainer:OPEN FIRMWARE AND...)

./arch/arm/boot/dts/imx53-smd.dts.get_maintainer
	Shawn Guo <shawn.guo@freescale.com> (maintainer:ARM/FREESCALE IMX...,authored lines:276/279=99%,commits:6/7=86%)
	Rob Herring <robh+dt@kernel.org> (maintainer:OPEN FIRMWARE AND...)

./arch/arm/boot/dts/r8a7791-koelsch.dts.get_maintainer
	Simon Horman <horms@verge.net.au> (supporter:ARM/SHMOBILE ARM...,commits:25/26=96%)
	Rob Herring <robh+dt@kernel.org> (maintainer:OPEN FIRMWARE AND...)

./arch/arm/boot/dts/r8a7790-lager.dts.get_maintainer
	Simon Horman <horms@verge.net.au> (supporter:ARM/SHMOBILE ARM...,commits:25/26=96%)
	Rob Herring <robh+dt@kernel.org> (maintainer:OPEN FIRMWARE AND...)

./Documentation/devicetree/bindings/vendor-prefixes.txt.get_maintainer
	Rob Herring <robh+dt@kernel.org> (maintainer:OPEN FIRMWARE AND...,commits:40/78=51%)

./Documentation/devicetree/bindings/i2c/trivial-devices.txt.get_maintainer
	Rob Herring <robh+dt@kernel.org> (maintainer:OPEN FIRMWARE AND...)

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

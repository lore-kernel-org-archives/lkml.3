Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaGNHWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:22:39 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:1038
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752173AbaGNHWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:22:30 -0400
From: Harini Katakam <harini.katakam@xilinx.com>
To: Mark Brown <broonie@kernel.org>
CC: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        =?iso-8859-2?Q?Marek_Va=B9ut?= <marex@denx.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jingoo Han <jg1.han@samsung.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Michal Simek <michals@xilinx.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>,
        "harinikatakamlinux@gmail.com" <harinikatakamlinux@gmail.com>,
        Harini Katakam <harinik@xilinx.com>
Subject: RE: [RFC PATCH 1/2] spi: Add support for Zynq QSPI controller
Thread-Topic: [RFC PATCH 1/2] spi: Add support for Zynq QSPI controller
Thread-Index: AQHPnBwMDmuTP/qsEEioHhovA7EZ15uY4q2AgAY/u0CAAArZEA==
Date: Mon, 14 Jul 2014 07:22:24 +0000
References: <1404982207-4707-1-git-send-email-harinik@xilinx.com>
 <1404982207-4707-2-git-send-email-harinik@xilinx.com>
 <CAMuHMdXO-PkQ+07F=aZEjvH1Kh7uhWK8i3V9w+1aHvvtg7wDoQ@mail.gmail.com>
 <CAFcVECJ93Lw1MRVU-=zLRbB6To--zmAxz8OLObu=mhV84-FTNA@mail.gmail.com>
 <CAMuHMdU2HyCwXBJTAyswyj7XqhzhHQ24MamGLLVgMwU4xi0kxQ@mail.gmail.com>
 <CAFcVEC+-bM91WmfwweDdTvJ7KwH+dxKDLkzsT82snWKhukLeYQ@mail.gmail.com>
 <20140710120120.GD30458@sirena.org.uk>
 <CAFcVECJvvch9Li0WihqoWcGNMMDVXfrujLUq6wvca46FztYpzA@mail.gmail.com>
 <20140710150713.GJ30458@sirena.org.uk>
 <03CA77BA8AF6F1469AEDFBDA1322A7B748213306@XAP-PVEXMBX01.xlnx.xilinx.com>
In-Reply-To: <03CA77BA8AF6F1469AEDFBDA1322A7B748213306@XAP-PVEXMBX01.xlnx.xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.18.13]
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <10e00662-1e08-4552-aae7-1e2029e56238@BY2FFO11FD051.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51704005)(377454003)(24454002)(199002)(189002)(13464003)(52314003)(81342001)(74316001)(95666004)(47776003)(20776003)(81542001)(2656002)(76482001)(106466001)(64706001)(1496007)(31966008)(107046002)(85306003)(77096002)(53416004)(93886003)(74502001)(74662001)(104016003)(106116001)(110136001)(83072002)(21056001)(50466002)(80022001)(86362001)(70736001)(31696002)(4396001)(79102001)(19580395003)(76176999)(6806004)(50986999)(83322001)(19580405001)(33646001)(46102001)(44976005)(99396002)(85852003)(87936001)(92726001)(92566001)(54356999)(77982001)(107986001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB031;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02723F29C4
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=harini.katakam@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

My mail seems to have missed the below reply.
Anyway, please find my answer below:

> -----Original Message-----
> From: Punnaiah Choudary Kalluri
> Sent: Monday, July 14, 2014 12:03 PM
> To: Harini Katakam
> Subject: FW: [RFC PATCH 1/2] spi: Add support for Zynq QSPI controller
> 
> 
> 
> >-----Original Message-----
> >From: Mark Brown [mailto:broonie@kernel.org]
> >Sent: Thursday, July 10, 2014 8:37 PM
> >To: Harini Katakam
> >Cc: Geert Uytterhoeven; Grant Likely; Rob Herring; Pawel Moll; Mark
> Rutland;
> >Ian Campbell; Kumar Gala; linux-spi; linux-kernel@vger.kernel.org;
> >devicetree@vger.kernel.org; linux-doc@vger.kernel.org; David
> Woodhouse;
> >Brian Norris; Marek Va¹ut; Artem Bityutskiy; Geert Uytterhoeven; Sascha
> >Hauer; Jingoo Han; Sourav Poddar; Michal Simek; Punnaiah Choudary
> Kalluri
> >Subject: Re: [RFC PATCH 1/2] spi: Add support for Zynq QSPI controller
> >
> >On Thu, Jul 10, 2014 at 06:09:55PM +0530, Harini Katakam wrote:
> >> On Thu, Jul 10, 2014 at 5:31 PM, Mark Brown <broonie@kernel.org>
> wrote:
> >
> >> > How does the client driver select the width to use for a transfer?
> >
> >> This controller is meant to be used only with flash devices.
> >> The flash devices' supported width will be reflected in a table in MTD
> layer.
> >> When selecting, priority is given to quad over dual and single in the MTD
> and
> >> it will send commands using the supported tx/rx bus width accordingly.
> >> About the supported bus width on board, tx-bus-width and rx-bus-width
> >> properties in dts will have the info; which I believe spi core uses.
> >
> >If it's only intended to be used as a flash controller (and might
> >misbehave if used as such, if the command detection false triggers) then
> >it is probably better to support it as a flash controller rather than as
> >a SPI controller.  Or can the flash-specific features be disabled?

There is provision to switch to legacy (generic spi) mode but it is not usually used.
As you can can see, the flash related specifics come into play only when two flash devices
are used. For a single slave, it will be generic.
As per your suggestions, I could send this driver in multiple stages -
Initially, qspi driver without flash specifics (this will work straight-away for a single flash)
In the next set, flash specifics changes for dual flash configurations (parallel/stacked)
Is that acceptable?

Regards,
Harini

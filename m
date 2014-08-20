Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaHTJ3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:29:13 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:42963
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751401AbaHTJ3M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:29:12 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCHv6 2/2] dt/bindings: Add the DT binding documentation for
 endianness
Thread-Topic: [PATCHv6 2/2] dt/bindings: Add the DT binding documentation for
 endianness
Thread-Index: AQHPn+T/m+2KM2DGoEGfjXOtBU3an5vZW1IAgAAQwuA=
Date: Wed, 20 Aug 2014 09:14:02 +0000
Message-ID: <10ad24319e6a486db77c31a5a911140e@BN1PR0301MB0609.namprd03.prod.outlook.com>
References: <1405398183-31345-1-git-send-email-Li.Xiubo@freescale.com>
 <1405398183-31345-3-git-send-email-Li.Xiubo@freescale.com>
 <20140820080549.GA15414@ulmo>
In-Reply-To: <20140820080549.GA15414@ulmo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 03094A4065
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(164054003)(24454002)(189002)(199003)(99286002)(108616004)(66066001)(101416001)(50986999)(83322001)(77096002)(19580395003)(76482001)(79102001)(76176999)(54356999)(99396002)(20776003)(95666004)(92566001)(77982001)(2656002)(74316001)(80022001)(106356001)(4396001)(105586002)(83072002)(31966008)(74502001)(21056001)(106116001)(74662001)(33646002)(110136001)(85306004)(85852003)(76576001)(64706001)(107046002)(46102001)(81542001)(81342001)(87936001)(86362001)(19580405001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0610;H:BN1PR0301MB0609.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCHv6 2/2] dt/bindings: Add the DT binding documentation for
> endianness
> 
> On Tue, Jul 15, 2014 at 12:23:03PM +0800, Xiubo Li wrote:
> > Device-Tree binding for device endianness
> > Index     Device     Endianness properties
> > ---------------------------------------------------
> > 1         BE         'big-endian'
> > 2         LE         'little-endian'
> >
> > For one device driver, which will run in different scenarios above
> > on different SoCs using the devicetree, we need one way to simplify
> > this.
> >
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> >  .../devicetree/bindings/regmap/regmap.txt          | 47
> ++++++++++++++++++++++
> >  1 file changed, 47 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/regmap/regmap.txt
> 
> Sorry for jumping in so late. I think this binding documentation needs
> to be moved somewhere else. regmap is a Linux kernel specific
> implementation detail and therefore has no place in device tree binding
> descriptions. Furthermore the endianness properties described herein do
> apply to drivers that don't use regmap.
> 
> Perhaps we need some top-level file that describes generic properties
> such as this?
> 
> Thierry

Yes, I do agree.
And there are many devices that have the endian issue without using the
Regmap in our LS* SoCs.

And I also think one generic binding description of this will be much
better.

Where should we place it? In Documentation/devicetree/bindings/, or...?


Thanks,

BRs
Xiubo



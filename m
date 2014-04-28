Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaD1IwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 04:52:23 -0400
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:31624
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751502AbaD1IwU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 04:52:20 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "rob@landley.net" <rob@landley.net>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 2/3] regmap: Add the DT binding documentation for
 endianness
Thread-Topic: [PATCHv2 2/3] regmap: Add the DT binding documentation for
 endianness
Thread-Index: AQHPXsXwE9oKGZnonkGmslBHS+BI6pse4biAgAfdchA=
Date: Mon, 28 Apr 2014 08:52:04 +0000
Message-ID: <39a09c53860c41248d2fd475c3691cd8@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1398235595-13370-1-git-send-email-Li.Xiubo@freescale.com>
 <1398235595-13370-3-git-send-email-Li.Xiubo@freescale.com>
 <20140423084009.GB30036@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140423084009.GB30036@e106331-lin.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01952C6E96
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(24454002)(51704005)(81342001)(77982001)(99286001)(20776003)(81542001)(50986999)(83072002)(66066001)(80976001)(86362001)(101416001)(74502001)(76176999)(74316001)(74662001)(87936001)(2656002)(46102001)(76576001)(80022001)(83322001)(19580395003)(77096999)(85852003)(4396001)(99396002)(54356999)(19580405001)(76482001)(79102001)(33646001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB505;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:25466016.2DC4C0D3.71F5B932.82B6D2C1.201BD;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCHv2 2/3] regmap: Add the DT binding documentation for
> endianness
> 
> On Wed, Apr 23, 2014 at 07:46:34AM +0100, Xiubo Li wrote:
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> >  .../bindings/regmap/regmap-endianness.txt          | 48
> ++++++++++++++++++++++
> >  1 file changed, 48 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/regmap/regmap-
> endianness.txt
> >
> > diff --git a/Documentation/devicetree/bindings/regmap/regmap-endianness.txt
> b/Documentation/devicetree/bindings/regmap/regmap-endianness.txt
> > new file mode 100644
> > index 0000000..1d838c5
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/regmap/regmap-endianness.txt
> > @@ -0,0 +1,48 @@
> > +Device-Tree bindings for regmap endianness
> 
> As regmap is a Linux internal detail, I don't see why it needs to leak
> into bindings.
> 
> > +Required properties:
> > +- regmap-reg-endian: register endianness, see ../endianness/endianness.txt
> > +  for detail.
> > +- regmap-val-endian: value endianness, see ../endianness/endianness.txt for
> 
> I'm not familiar with regmap. What is the difference between register
> and value endianness?
>

Sorry for late, I'm very busy these days.

The register endianness here is used for the I2C and SPI protocol, which will
Send the register address(which maybe 8-bit or 16-bit) before its values.
 
BRs
Xiubo

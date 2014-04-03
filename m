Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162398AbaDCHEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:04:32 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:34730
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1162382AbaDCHEG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:04:06 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 2/3] regmap: Add the DT binding documentation for
 endianness
Thread-Topic: [PATCHv2 2/3] regmap: Add the DT binding documentation for
 endianness
Thread-Index: AQHPTmGjdrGV9rYnBkeeS8Q3q4yK7Zr+vDIAgAB8PNA=
Date: Thu, 3 Apr 2014 07:04:00 +0000
Message-ID: <bebf1cf679014e62b1f4ad3fa970b52f@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1396433349-31470-1-git-send-email-Li.Xiubo@freescale.com>
 <1396433349-31470-3-git-send-email-Li.Xiubo@freescale.com>
 <20140402194812.GK14763@sirena.org.uk>
In-Reply-To: <20140402194812.GK14763@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(199002)(164054003)(189002)(51704005)(95416001)(81686001)(93516002)(93136001)(80976001)(51856001)(86362001)(85852003)(2656002)(94316002)(94946001)(97186001)(95666003)(56816005)(90146001)(81816001)(87266001)(97336001)(19580405001)(46102001)(92566001)(87936001)(74706001)(85306002)(76482001)(83072002)(54356001)(99286001)(4396001)(47976001)(81342001)(47446002)(98676001)(49866001)(33646001)(74316001)(76786001)(54316002)(56776001)(76796001)(76576001)(65816001)(50986001)(31966008)(69226001)(74502001)(53806001)(20776003)(74366001)(83322001)(81542001)(74876001)(47736001)(74662001)(99396002)(66066001)(63696002)(79102001)(77982001)(80022001)(59766001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB508;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:BE59FBA6.1F325E19.33C5B77E.48E5A971.20246;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
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
> On Wed, Apr 02, 2014 at 06:09:08PM +0800, Xiubo Li wrote:
> 
> > +sai2: sai@40031000 {
> > +	      compatible = "fsl,vf610-sai";
> > +	      reg = <0x40031000 0x1000>;
> > +	      ...
> > +	      val-endian = 'LE';
> > +};
> 
> This is mostly OK as a binding (though it should be CCed to the DT list
> and maintiners as all DT bindings should) except using upper case
> doesn't really seem idiomatic for DT - lower case is more normal - 

I will your advices.


> and I
> don't think we can make these properties mandatory in themselves.
> Individual bindings would need to make them mandatory.  It's also odd to
> have a mandatory property which may be absent!

Well, yes, It is.

The absent one is just to compatible with the old drivers.



> 
> It'd probably be better if the binding defined what the default
> endianess was too, or just didn't say what happens in cases where
> nothing is specified, the latter seems better.  

I will think it over carefully.


> Generally just not
> mentioning regmap is better for a binding definition, the binding should
> be usable by all OSs and not just Linux.

How about move the endianness OF parsing to the driver/of/ ?
Is this will be better ?

Thanks,

BRs
Xiubo




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaDWFI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:08:26 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:33062
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751436AbaDWFIY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:08:24 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 2/3] regmap: Add the DT binding documentation for
 endianness
Thread-Topic: [PATCHv2 2/3] regmap: Add the DT binding documentation for
 endianness
Thread-Index: AQHPTmGjdrGV9rYnBkeeS8Q3q4yK7Zr+vDIAgAB8PNCAEnaKAIANGArw
Date: Wed, 23 Apr 2014 05:08:21 +0000
Message-ID: <75b16e54bf814a05b4e6bd4f3c005d13@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1396433349-31470-1-git-send-email-Li.Xiubo@freescale.com>
 <1396433349-31470-3-git-send-email-Li.Xiubo@freescale.com>
 <20140402194812.GK14763@sirena.org.uk>
 <bebf1cf679014e62b1f4ad3fa970b52f@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140414210948.GB12304@sirena.org.uk>
In-Reply-To: <20140414210948.GB12304@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01901B3451
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(51704005)(13464003)(377454003)(164054003)(24454002)(77982001)(79102001)(85852003)(83072002)(86362001)(81542001)(76576001)(99286001)(20776003)(80022001)(2656002)(92566001)(31966008)(74502001)(81342001)(74662001)(19580395003)(87936001)(74316001)(80976001)(83322001)(33646001)(76482001)(46102001)(50986999)(76176999)(54356999)(66066001)(77096999)(19580405001)(99396002)(4396001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB507;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:B61EF89A.1CE0641A.72C12B53.FAEBF9.2019B;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Tuesday, April 15, 2014 5:10 AM
> To: Xiubo Li-B47053
> Cc: linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCHv2 2/3] regmap: Add the DT binding documentation for
> endianness
> 
> On Thu, Apr 03, 2014 at 07:04:00AM +0000, Li.Xiubo@freescale.com wrote:
> 
> > > Generally just not
> > > mentioning regmap is better for a binding definition, the binding should
> > > be usable by all OSs and not just Linux.
> 
> > How about move the endianness OF parsing to the driver/of/ ?
> > Is this will be better ?
> 
> Where the code is is sensible enough, it's an issue about how the
> binding documentation was written rather than about the code.

Sorry for late.

Well, I will try to enhance this.

Thanks,

BRs
Xiubo

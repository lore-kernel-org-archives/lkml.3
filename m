Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161574AbaDCF1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 01:27:12 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:22263
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161512AbaDCF1C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 01:27:02 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 3/3] regmap: add DT endianness binding support.
Thread-Topic: [PATCHv2 3/3] regmap: add DT endianness binding support.
Thread-Index: AQHPTmGivzgqZxqtXk2LP0z0kKtiUJr+vM6AgACe6FA=
Date: Thu, 3 Apr 2014 05:26:57 +0000
Message-ID: <aeccb18d5442446cac4030b86c3455c1@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1396433349-31470-1-git-send-email-Li.Xiubo@freescale.com>
 <1396433349-31470-4-git-send-email-Li.Xiubo@freescale.com>
 <20140402195023.GL14763@sirena.org.uk>
In-Reply-To: <20140402195023.GL14763@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(24454002)(164054003)(189002)(199002)(85306002)(95416001)(81816001)(86362001)(83072002)(85852003)(81686001)(80976001)(76786001)(76796001)(74366001)(93136001)(2656002)(76576001)(74316001)(79102001)(87266001)(92566001)(93516002)(87936001)(69226001)(97186001)(74876001)(81342001)(59766001)(77982001)(97336001)(20776003)(81542001)(51856001)(56816005)(90146001)(46102001)(99286001)(99396002)(98676001)(47976001)(50986001)(63696002)(74706001)(4396001)(47736001)(33646001)(49866001)(80022001)(65816001)(74662001)(74502001)(95666003)(31966008)(66066001)(47446002)(83322001)(94946001)(94316002)(76482001)(53806001)(54356001)(56776001)(54316002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB506;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:3C3A4770.D7A26819.33F1ABFE.48B499B1.2014D;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [PATCHv2 3/3] regmap: add DT endianness binding support.
> 
> On Wed, Apr 02, 2014 at 06:09:09PM +0800, Xiubo Li wrote:
> 
> > +	ret = of_regmap_get_endian(dev, bus, config, "reg_endian", &reg_endian);
> > +	if (ret)
> > +		return ERR_PTR(ret);
> > +
> > +	ret = of_regmap_get_endian(dev, bus, config, "val_endian", &val_endian);
> > +	if (ret)
> > +		return ERR_PTR(ret);
> 
> Actually, if we're going to be doing this for all devices then we
> probably need to namespace the properties too.  Not sure what to do for
> a prefix though.  One for the DT folks.

How about using one prefix string of each regmap bus?
Such as:
Prefix 'regmap-mmio' for regmap-mmio,
Prefix 'regmap-i2c' for regmap-i2c,
Precix 'regmap-spi' for regmap-spi
...

Or just using the same prefix 'regmap' for all of them ?

Thanks,

BRs
Xiubo

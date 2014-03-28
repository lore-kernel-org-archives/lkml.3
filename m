Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233AbaC1GYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 02:24:38 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:25115
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751125AbaC1GYh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 02:24:37 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] regmap: Add REGMAP_ENDIAN_SWAP support for values.
Thread-Topic: [PATCH] regmap: Add REGMAP_ENDIAN_SWAP support for values.
Thread-Index: AQHPSZr7/iscv9ds3UCCyTVsT9czvJr0z4qAgAE0sXA=
Date: Fri, 28 Mar 2014 06:24:33 +0000
Message-ID: <791ba45eb211460b9530099b77637257@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1395908259-1832-1-git-send-email-Li.Xiubo@freescale.com>
 <20140327114039.GJ30768@sirena.org.uk>
In-Reply-To: <20140327114039.GJ30768@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01644DCF4A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(199002)(189002)(24454002)(93136001)(97336001)(97186001)(74876001)(74706001)(74366001)(74316001)(46102001)(94946001)(56816005)(90146001)(53806001)(85852003)(54356001)(94316002)(83072002)(51856001)(95666003)(95416001)(76482001)(98676001)(93516002)(92566001)(56776001)(54316002)(4396001)(50986001)(47976001)(47736001)(49866001)(47446002)(81342001)(86362001)(81542001)(20776003)(63696002)(77982001)(59766001)(85306002)(79102001)(81816001)(74662001)(83322001)(76796001)(76576001)(74502001)(31966008)(66066001)(76786001)(81686001)(87936001)(2656002)(80976001)(87266001)(33646001)(65816001)(80022001)(69226001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB507;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:3AE403F7.19334CAB.B0FD5543.44EEF140.20135;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCH] regmap: Add REGMAP_ENDIAN_SWAP support for values.
> 
> On Thu, Mar 27, 2014 at 04:17:39PM +0800, Xiubo Li wrote:
> 
> > And using the REGMAP_ENDIAN_BIG and REGMAP_ENDIAN_LITTLE will make
> > the driver a bit more complex, and also the usage of it.
> 
> What's the complexity here?

Well, maybe it not as complex as it likes, just relatively:

For some drivers that may support the following cases:

For the DT node:

CPU        Dev        LE/BE property need ?
----------------------------------------------
LE         LE         No
LE         BE         'big-endian' property
BE         BE         No
BE         LE         'little-endian' property

The driver will adapt to this too.

Thanks :)

Best Regards,
Xiubo



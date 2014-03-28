Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbaC1JXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 05:23:34 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:59170
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751267AbaC1JXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 05:23:33 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] regmap: Add REGMAP_ENDIAN_SWAP support for values.
Thread-Topic: [PATCH] regmap: Add REGMAP_ENDIAN_SWAP support for values.
Thread-Index: AQHPSZr7/iscv9ds3UCCyTVsT9czvJr0z4qAgAFYF4A=
Date: Fri, 28 Mar 2014 09:23:29 +0000
Message-ID: <a68732b27c1e4f46a2cf945afdfd9817@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1395908259-1832-1-git-send-email-Li.Xiubo@freescale.com>
 <20140327114039.GJ30768@sirena.org.uk>
In-Reply-To: <20140327114039.GJ30768@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01644DCF4A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(164054003)(51704005)(189002)(199002)(76482001)(54356001)(53806001)(54316002)(56776001)(81542001)(81342001)(49866001)(46102001)(47736001)(50986001)(47976001)(69226001)(4396001)(51856001)(97186001)(81816001)(81686001)(33646001)(74662001)(74502001)(31966008)(47446002)(97336001)(93136001)(92566001)(98676001)(85306002)(87266001)(87936001)(85852003)(2656002)(83072002)(90146001)(56816005)(76796001)(76786001)(76576001)(95666003)(83322001)(80976001)(94316002)(94946001)(86362001)(95416001)(93516002)(74366001)(65816001)(63696002)(77982001)(59766001)(74316001)(20776003)(74876001)(74706001)(79102001)(66066001)(80022001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB506;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:2C15C210.1CF2F029.79E9B18E.54E6F2F5.20177;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
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
> > For the DT node, just one property like 'endian-swap' will be okey
> > for cases 2 and 4.
> 
> I'm not convinced that the cost of having to define explicit big and
> little endian properties for the hardware is worth having this - it
> seems like a confusing thing to have in the interface since it depends
> on both the device and the CPU and would presumably break in cases where
> there's an option about which endianness to run things in.
> 

Yes, Actually that's may happen.

I'll implement the REGMAP_ENDIAN_LITTLE.

Thanks,

Best Regards,
Xiubo

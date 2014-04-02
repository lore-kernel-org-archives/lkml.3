Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbaDBHdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:33:14 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:55330
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756574AbaDBHdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:33:12 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: Guenter Roeck <linux@roeck-us.net>, "wim@iguana.be" <wim@iguana.be>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 2/2] watchdog: imx2_wdt: Add big-endian support
Thread-Topic: [PATCHv2 2/2] watchdog: imx2_wdt: Add big-endian support
Thread-Index: AQHPSKDVcbPU6SPqA024POxEUieEfpr6ko0AgAAGE3CAAW5SgIAAAFPggACyPgCAAUCM4A==
Date: Wed, 2 Apr 2014 07:33:08 +0000
Message-ID: <52646eae41aa44068a32201ae9c0fff3@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1395800500-22655-1-git-send-email-Li.Xiubo@freescale.com>
 <1395800500-22655-3-git-send-email-Li.Xiubo@freescale.com>
 <5338E1E8.4030700@roeck-us.net>
 <28375308b05f4cf4bc7d1559f2524c1b@BY2PR03MB505.namprd03.prod.outlook.com>
 <533A1A4B.2090503@roeck-us.net>
 <1c79a81bbd7b4cc79689cb907e81e893@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140401122454.GS2269@sirena.org.uk>
In-Reply-To: <20140401122454.GS2269@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(24454002)(199002)(189002)(99286001)(97336001)(51856001)(86362001)(87266001)(74876001)(54356001)(97186001)(87936001)(74706001)(94316002)(76482001)(19580405001)(83322001)(19580395003)(54316002)(81342001)(81816001)(85852003)(74502001)(83072002)(20776003)(81686001)(74316001)(76786001)(63696002)(47736001)(47976001)(47446002)(79102001)(50986001)(59766001)(77982001)(81542001)(98676001)(74366001)(53806001)(93136001)(95416001)(93516002)(76576001)(69226001)(49866001)(46102001)(95666003)(66066001)(65816001)(2656002)(92566001)(80976001)(31966008)(33646001)(74662001)(94946001)(85306002)(56816005)(80022001)(90146001)(99396002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB505;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:FF5745BE.9CF00C11.BAD17F40.64C4E2E1.20150;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCHv2 2/2] watchdog: imx2_wdt: Add big-endian support
> 
> On Tue, Apr 01, 2014 at 02:24:12AM +0000, Li.Xiubo@freescale.com wrote:
> 
> > Yes, I do think so too and there has already regmap-mmio version patch
> > Series about the IMX2 Watchdog driver, but those regmap patches for
> > supporting the 16-bit values are in Mark's tree and the IMX2 Watchdog
> > will depend on them.
> 
> > How to deal with this situation ?
> 
> Well, anything that's already applied went to Linus already so is in
> -rc1.  Anything else we can either do a cross tree merge or I can apply
> the driver.

That's great.

Thanks very much,

BRs
Xiubo

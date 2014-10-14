Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbaJNBww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 21:52:52 -0400
Received: from mail-by2on0127.outbound.protection.outlook.com ([207.46.100.127]:28502
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754565AbaJNBwu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 21:52:50 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dp@opensource.wolfsonmicro.com" <dp@opensource.wolfsonmicro.com>
Subject: RE: [PATCH 2/6] regmap: cache: cleanup regcache_hw_init().
Thread-Topic: [PATCH 2/6] regmap: cache: cleanup regcache_hw_init().
Thread-Index: AQHP45/nWVV96Oe+skSyutrZg0NFZJwt3uAAgAD8DrA=
Date: Tue, 14 Oct 2014 01:52:48 +0000
Message-ID: <e4424702b10c49a1a04b713b3e00a55d@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1412845377-17134-1-git-send-email-Li.Xiubo@freescale.com>
 <1412845377-17134-3-git-send-email-Li.Xiubo@freescale.com>
 <20141013104720.GM27755@sirena.org.uk>
In-Reply-To: <20141013104720.GM27755@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
x-forefront-prvs: 03648EFF89
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(189002)(24454002)(54534003)(20776003)(64706001)(21056001)(97736003)(122556002)(50986999)(76176999)(99396003)(54356999)(76482002)(46102003)(80022003)(101416001)(31966008)(2656002)(87936001)(66066001)(85306004)(85852003)(74316001)(106116001)(92566001)(108616004)(4396001)(110136001)(86362001)(120916001)(40100003)(105586002)(106356001)(95666004)(76576001)(99286002)(33646002)(107046002)(77096002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0614;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> Subject: Re: [PATCH 2/6] regmap: cache: cleanup regcache_hw_init().
> 
> On Thu, Oct 09, 2014 at 05:02:53PM +0800, Xiubo Li wrote:
> > Remove the redundant code for regmap cache.
> 
> Applied, thanks.  With changes like this it is much better if the
> changelog explains why the code is redundant - say in words that the
> value used is never referenced and looking up the value has no side
> effects.

Thanks verrrry much for your comment and your always patient guidance.

BRs
Xiubo 

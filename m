Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaI3FGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 01:06:04 -0400
Received: from mail-by2on0145.outbound.protection.outlook.com ([207.46.100.145]:62148
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750830AbaI3FGC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 01:06:02 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] regmap: fix possible ZERO_SIZE_PTR pointer dereferencing
 error.
Thread-Topic: [PATCH] regmap: fix possible ZERO_SIZE_PTR pointer dereferencing
 error.
Thread-Index: AQHP2vwEQH8thzKh4E+SycHmmgvtd5wWX6AAgALCY0A=
Date: Tue, 30 Sep 2014 05:05:58 +0000
Message-ID: <ef762901b7f340ce9ad3d0e43e02380e@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1411895394-25250-1-git-send-email-Li.Xiubo@freescale.com>
 <20140928105604.GT27755@sirena.org.uk>
In-Reply-To: <20140928105604.GT27755@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0615;
x-forefront-prvs: 0350D7A55D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(164054003)(2656002)(21056001)(86362001)(64706001)(85852003)(101416001)(120916001)(99396003)(92566001)(10300001)(20776003)(76576001)(87936001)(80022003)(31966008)(46102003)(99286002)(97736003)(95666004)(108616004)(74316001)(85306004)(33646002)(76176999)(4396001)(76482002)(54356999)(105586002)(66066001)(106356001)(107046002)(110136001)(50986999)(106116001)(77096002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0615;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> 
> > diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> > index 455a877..3d93e38 100644
> > --- a/drivers/base/regmap/regmap.c
> > +++ b/drivers/base/regmap/regmap.c
> > @@ -1716,6 +1716,9 @@ out:
> 
> Whatever you're using to generate the patches isn't annotating with the
> function being changed like git normally does which isn't great for
> working out what the best return value should be.

Yes, I will add more detail info about the return value in future of these
kind patches.

Thanks,

BRs
Xiubo


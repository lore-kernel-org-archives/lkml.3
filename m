Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbaIIJzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:55:46 -0400
Received: from mail-by2on0104.outbound.protection.outlook.com ([207.46.100.104]:25888
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752901AbaIIJzp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:55:45 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "shengjiu.wang@freescale.com" <shengjiu.wang@freescale.com>,
        "timur@tabi.org" <timur@tabi.org>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
Thread-Topic: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
Thread-Index: AQHPzA8IY+MC89WRk0mMBVxSnerawJv4j9tA
Date: Tue, 9 Sep 2014 09:55:41 +0000
Message-ID: <a2df014417624f0790c01b0ccd21853f@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
In-Reply-To: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0329B15C8A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019018)(6009001)(199003)(189002)(164054003)(51704005)(79102001)(64706001)(2656002)(74662001)(2501002)(106116001)(66066001)(90102001)(21056001)(97736003)(33646002)(106356001)(2201001)(92566001)(20776003)(87936001)(99286002)(76482001)(86362001)(80022001)(85306004)(108616004)(76576001)(74316001)(101416001)(77096002)(50986999)(46102001)(105586002)(77982001)(4396001)(76176999)(99396002)(95666004)(31966008)(107046002)(83322001)(81542001)(83072002)(74502001)(54356999)(81342001)(85852003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB329;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Subject: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
> 
> Move the ipg clock enable and disable operation to startup and shutdown,
> that is only enable ipg clock when ssi is working. we don't need to enable
> ipg clock in probe.
> Another register accessing need the ipg clock, so use
> devm_regmap_init_mmio_clk
> instead of devm_regmap_init_mmio.
>

You should split this into two separate patches, which will be more
Easy to be reviewed.
 
Thanks,

BRs
Xiubo


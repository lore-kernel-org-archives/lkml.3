Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaIACCi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 22:02:38 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:54517
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751679AbaIACCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 22:02:37 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Jean-Francois Moine <moinejf@free.fr>, Jyri Sarha <jsarha@ti.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>
Subject: RE: [RFC][PATCH] ASoC: simple-card: Merge single and muti DAI link
 code.
Thread-Topic: [RFC][PATCH] ASoC: simple-card: Merge single and muti DAI link
 code.
Thread-Index: AQHPw1WlKghmtyQaZ0ed1b/HG05M45vnewOAgAQPT7A=
Date: Mon, 1 Sep 2014 02:02:33 +0000
Message-ID: <0a58aefde8594877be9fa7199f6c3d3e@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409294797-21948-1-git-send-email-Li.Xiubo@freescale.com>
 <20140829120035.GW29327@sirena.org.uk>
In-Reply-To: <20140829120035.GW29327@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 03218BFD9F
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(13464003)(51704005)(164054003)(189002)(24454002)(377454003)(199003)(110136001)(85852003)(31966008)(74502001)(87936001)(76482001)(83322001)(19580405001)(19580395003)(99286002)(105586002)(77982001)(79102001)(107046002)(99396002)(106116001)(83072002)(92566001)(101416001)(77096002)(76176999)(21056001)(80022001)(66066001)(20776003)(64706001)(46102001)(108616004)(76576001)(90102001)(95666004)(2656002)(85306004)(74316001)(106356001)(81542001)(86362001)(33646002)(54356999)(81342001)(4396001)(50986999)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0615;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark, Kuninori-san,

Very sorry, I just missed that patch series.

See the next version.

Thanks,

BRs
Xiubo




> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Friday, August 29, 2014 8:01 PM
> To: Xiubo Li-B47053
> Cc: alsa-devel@alsa-project.org; linux-kernel@vger.kernel.org;
> devicetree@vger.kernel.org; Kuninori Morimoto; Jean-Francois Moine; Jyri Sarha;
> Nicolin Chen
> Subject: Re: [RFC][PATCH] ASoC: simple-card: Merge single and muti DAI link
> code.
> 
> On Fri, Aug 29, 2014 at 02:46:37PM +0800, Xiubo Li wrote:
> > This patch merge single DAI link and muti-DAI links code together,
> > and simply the simple-card driver code.
> 
> This will need to be rebased on Morimoto-san's changes I believe.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbaIBDi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 23:38:26 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:7749
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751832AbaIBDiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 23:38:25 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>, Andrew Lunn <andrew@lunn.ch>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "moinejf@free.fr" <moinejf@free.fr>, "jsarha@ti.com" <jsarha@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Shawn Guo <Shawn.Guo@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolin Chen <nicoleotsuka@gmail.com>
Subject: RE: [PATCHv1 1/7] ASoC: simple-card: Merge single and muti DAI link
 code.
Thread-Topic: [PATCHv1 1/7] ASoC: simple-card: Merge single and muti DAI link
 code.
Thread-Index: AQHPxaSIjDKMe5GZe0qIhLyq1msviJvsR4sAgAAb3gCAAMXSgA==
Date: Tue, 2 Sep 2014 03:22:24 +0000
Message-ID: <1b29c16ac3944bb19940da886bf7da3a@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
 <1409545781-20530-2-git-send-email-Li.Xiubo@freescale.com>
 <20140901133412.GA11312@lunn.ch> <20140901151356.GB29327@sirena.org.uk>
In-Reply-To: <20140901151356.GB29327@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
x-forefront-prvs: 0322B4EDE1
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(164054003)(24454002)(51704005)(189002)(199003)(105586002)(64706001)(87936001)(92566001)(21056001)(50986999)(106116001)(86362001)(77982001)(79102001)(101416001)(83072002)(85852003)(66066001)(76482001)(46102001)(80022001)(83322001)(95666004)(107046002)(99286002)(76576001)(4396001)(90102001)(54356999)(20776003)(33646002)(31966008)(81542001)(99396002)(81342001)(108616004)(93886004)(2656002)(76176999)(77096002)(85306004)(74316001)(74502001)(74662001)(106356001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB342;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Mon, Sep 01, 2014 at 03:34:12PM +0200, Andrew Lunn wrote:
> > On Mon, Sep 01, 2014 at 12:29:35PM +0800, Xiubo Li wrote:
> > > This patch merge single DAI link and muti-DAI links code together,
> > > and simply the simple-card driver code.
> 
> > It would be good to note that this breaks the Binary API with DT
> > blobs. Old blobs will not work with this new C code.
> 
> That's not on, we need to maintian compatibility with the old DTs unless
> there's a very strong reason not to.  Revising the binding is one option
> for doing this, keeping the old binding in place and making a v2 binding
> with the new functionality.

Yes, agree.

Actually, the current code is a bit more complicated that we should keep in mind
of two styles of single DAI link and muti-DAI links. And the binding document and
code are a little unreadable.

For others must read the simple card code carefully to add one DT node.

Thanks,

BRs


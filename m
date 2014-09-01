Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaIAGwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:52:32 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:57131
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750885AbaIAGwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:52:31 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Jean-Francois Moine <moinejf@free.fr>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "jsarha@ti.com" <jsarha@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 1/2] ASoC: simple-card: Fix bug of forgetting decrement
 DT node's refcount
Thread-Topic: [PATCHv2 1/2] ASoC: simple-card: Fix bug of forgetting decrement
 DT node's refcount
Thread-Index: AQHPxYwy8jPllsIeZkuglIVIZS07M5vr000AgAAD/dA=
Date: Mon, 1 Sep 2014 06:52:26 +0000
Message-ID: <11d26ed010ad4cc9b90f44bff56340c3@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409535327-11449-1-git-send-email-Li.Xiubo@freescale.com>
	<1409535327-11449-2-git-send-email-Li.Xiubo@freescale.com>
 <20140901083728.01454558@armhf>
In-Reply-To: <20140901083728.01454558@armhf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
x-forefront-prvs: 03218BFD9F
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(51704005)(199003)(164054003)(108616004)(81342001)(74502001)(87936001)(86362001)(31966008)(80022001)(81542001)(4396001)(90102001)(79102001)(106116001)(77096002)(77982001)(101416001)(107046002)(20776003)(85852003)(76176999)(66066001)(74316001)(110136001)(2656002)(95666004)(54356999)(76576001)(50986999)(99286002)(92566001)(21056001)(76482001)(74662001)(19580405001)(46102001)(105586002)(33646002)(19580395003)(85306004)(106356001)(83322001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0613;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s816qcYj003176


> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> >  sound/soc/generic/simple-card.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-
> card.c
> > index fd8b045..9e170fe 100644
> > --- a/sound/soc/generic/simple-card.c
> > +++ b/sound/soc/generic/simple-card.c
> > @@ -360,6 +360,7 @@ static int asoc_simple_card_parse_of(struct device_node
> *node,
> >  			}
> >  			i++;
> >  		}
> > +		of_node_put(np);
> >  	} else {
> >  		ret = asoc_simple_card_dai_link_of(node, dev,
> >  						   dai_link, dai_props, true);
> 
> No. np is NULL at end of loop.
> 

Well, yes, you are right.

Thanks,

BRs
Xiubo

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaA2LwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 06:52:17 -0500
Received: from mail-bn1lp0158.outbound.protection.outlook.com ([207.46.163.158]:59210
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbaA2LwL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 06:52:11 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "rob@landley.net" <rob@landley.net>, "perex@perex.cz" <perex@perex.cz>,
        "moinejf@free.fr" <moinejf@free.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: RE: [PATCH v2 5/7] ASoC: add snd_soc_of_parse_audio_simple_widgets
 for DT
Thread-Topic: [PATCH v2 5/7] ASoC: add snd_soc_of_parse_audio_simple_widgets
 for DT
Thread-Index: AQHPGOCWUlsJwU28O0aJBBem7kVvaJqZAcaAgAKczTI=
Date: Wed, 29 Jan 2014 11:52:08 +0000
Message-ID: <4b698a662f2649cdae6e146c4cb9618c@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1390549386-4702-1-git-send-email-Li.Xiubo@freescale.com>
 <1390549386-4702-6-git-send-email-Li.Xiubo@freescale.com>,<20140127195545.GZ11841@sirena.org.uk>
In-Reply-To: <20140127195545.GZ11841@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [115.49.141.227]
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(189002)(199002)(164054003)(76786001)(74876001)(81816001)(50986001)(83322001)(47736001)(47976001)(74706001)(90146001)(74316001)(76796001)(74366001)(80976001)(85306002)(56816005)(69226001)(93136001)(49866001)(81686001)(86362001)(4396001)(81342001)(53806001)(33646001)(59766001)(76576001)(76482001)(87936001)(79102001)(54356001)(74662001)(31966008)(85852003)(66066001)(83072002)(87266001)(54316002)(46102001)(81542001)(56776001)(63696002)(51856001)(93516002)(92566001)(77982001)(74502001)(80022001)(47446002)(65816001)(94316002)(2656002)(8406003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB507;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:115.49.141.227;FPR:;InfoNoRecordsMX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > The "template-wname" includes: "Mic", "Line", "Hp", "Spk"...
>
> Sorry, this is nitpicking but can we have "HP" or even "Headphone"
> instead of "Hp" - otherwise it looks like a typo and people might
> correct it.  Similarly "Speaker" might be better as "Spk".

Yes, I will  use them.

Please see the next version days later.

Thanks,

--
Best Regards,
Xiubo
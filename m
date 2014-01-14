Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaANOn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:43:57 -0500
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:31090
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751722AbaANOnx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:43:53 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Jean-Francois Moine <moinejf@free.fr>
CC: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>
Subject: RE: [alsa-devel] [RFC][PATCH] ASoC: simple-card: Add
 asoc_simple_card_data for the simple card driver data
Thread-Topic: [alsa-devel] [RFC][PATCH] ASoC: simple-card: Add
 asoc_simple_card_data for the simple card driver data
Thread-Index: AQHPERknbFtgLOnVak+t7LEafhKfHJqESji/
Date: Tue, 14 Jan 2014 14:43:51 +0000
Message-ID: <9a2f6818586c4dfb9a5e0a019c6a2b06@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1389678282-1097-1-git-send-email-Li.Xiubo@freescale.com>
	<871u0bgiai.wl%kuninori.morimoto.gx@gmail.com>
	<96cb876ff05c4062ab5a2c92fb7b3c41@BY2PR03MB505.namprd03.prod.outlook.com>,<20140114120913.19d883fe@armhf>
In-Reply-To: <20140114120913.19d883fe@armhf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [211.155.113.244]
x-forefront-prvs: 0091C8F1EB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(779001)(689001)(679001)(164054003)(199002)(189002)(85852003)(83072002)(51856001)(56816005)(2656002)(33646001)(76796001)(93136001)(87266001)(74366001)(76482001)(63696002)(47446002)(31966008)(54316002)(74502001)(66066001)(80022001)(65816001)(74662001)(74316001)(90146001)(74876001)(74706001)(46102001)(54356001)(77982001)(83322001)(53806001)(4396001)(81816001)(56776001)(92566001)(49866001)(69226001)(79102001)(76576001)(87936001)(76786001)(80976001)(59766001)(558084003)(47736001)(81686001)(47976001)(85306002)(81342001)(50986001)(81542001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB507;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:211.155.113.244;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Jean-Francios,


I do think split the muti-issues into deferent patches will be easier to
upstream code, and the risk will be lower.

So this patch is just the first step.

Thanks,

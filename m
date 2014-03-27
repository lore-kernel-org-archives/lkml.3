Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaC0ESc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 00:18:32 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:51010
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751398AbaC0ESb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 00:18:31 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: RE: [PATCH] ASoC: fsl_sai: Add isr to deal with error flag
Thread-Topic: [PATCH] ASoC: fsl_sai: Add isr to deal with error flag
Thread-Index: AQHPSOk07qbuL0Yc9E6K9N8Cg7O135r0MFsAgAAIfACAAAOIEIAAAjIAgAALYOD///5EAIAAB+Kw////bICAAAWcwA==
Date: Thu, 27 Mar 2014 04:18:27 +0000
Message-ID: <d77b7d1800884badbdb50564b8460267@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1395834517-16426-1-git-send-email-Guangyu.Chen@freescale.com>
 <11a8271c31044515bd2657a93aefdaec@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140327023617.GB16197@MrMyself>
 <1e2d210764724c7e834c5307b54c37ab@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140327025647.GC16197@MrMyself>
 <12f887b3889a41849026965f0cf7db1f@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140327033117.GD16197@MrMyself>
 <62630844c7434df6937ca25d3f47b656@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140327035726.GA16359@MrMyself>
In-Reply-To: <20140327035726.GA16359@MrMyself>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.212]
x-forefront-prvs: 01630974C0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(164054003)(189002)(51704005)(199002)(47446002)(54316002)(31966008)(74876001)(74502001)(74662001)(93136001)(51856001)(81686001)(95666003)(46102001)(93516002)(86362001)(95416001)(94946001)(83322001)(66066001)(54356001)(81542001)(53806001)(83072002)(97336001)(76482001)(56776001)(97186001)(69226001)(81342001)(81816001)(56816005)(94316002)(85852003)(49866001)(59766001)(74706001)(80022001)(76796001)(85306002)(79102001)(77982001)(92566001)(98676001)(87936001)(90146001)(80976001)(63696002)(87266001)(20776003)(76576001)(47976001)(76786001)(2656002)(47736001)(65816001)(4396001)(74366001)(33646001)(50986001)(74316001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB441;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:F9D0628E.8FE0472B.29EDB768.CDAA8E0.2014E;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So let's just ignore the clearance of these bits in isr().
> >
> > +++++
> > SAI Transmit Control Register (I2S1_TCSR) : 32 : R/W : 0000_0000h
> 
> I'm talking about FWF and FRF bits, not TCSR as a register.
> 
> > -----
> >
> > I have checked in the Vybrid and LS1 SoC datasheets, and they are all the
> > Same as above, and nothing else.
> >
> > Have I missed ?
> 
> What i.MX IC team told me is SAI ignores what we do to FWF and FRF, so you
> don't need to worry about it at all unless Vybrid makes them writable, in
> which case we may also need to clear these bits and confirm with Vybrid IC
> team if they're also W1C.
> 

Well, if so, that's fine.

Thanks,

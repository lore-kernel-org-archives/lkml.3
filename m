Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbaBSHZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 02:25:50 -0500
Received: from mail-bn1lp0152.outbound.protection.outlook.com ([207.46.163.152]:17371
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbaBSHZs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 02:25:48 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/4] ARM: dts: Enable SAI ALSA SoC DAI device for Vybrid
 VF610 TOWER board.
Thread-Topic: [PATCH 2/4] ARM: dts: Enable SAI ALSA SoC DAI device for
 Vybrid VF610 TOWER board.
Thread-Index: AQHPLT33gQBOLBof5EOxeWzeL2k+mpq8J8AAgAAE5nA=
Date: Wed, 19 Feb 2014 07:25:43 +0000
Message-ID: <ea66b1869211439f96598b54e24e282a@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1392788323-6092-1-git-send-email-Li.Xiubo@freescale.com>
 <1392788323-6092-3-git-send-email-Li.Xiubo@freescale.com>
 <20140219070630.GE3010@S2101-09.ap.freescale.net>
In-Reply-To: <20140219070630.GE3010@S2101-09.ap.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.215]
x-forefront-prvs: 012792EC17
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(199002)(189002)(164054003)(51704005)(51856001)(69226001)(95666001)(95416001)(81342001)(94316002)(74876001)(76796001)(81816001)(76786001)(53806001)(76576001)(54356001)(33646001)(94946001)(56776001)(54316002)(74706001)(81686001)(76482001)(93516002)(86362001)(93136001)(81542001)(575784001)(87936001)(80976001)(4396001)(63696002)(87266001)(85306002)(49866001)(56816005)(83322001)(47446002)(50986001)(74662001)(74316001)(74366001)(65816001)(74502001)(47736001)(66066001)(92566001)(47976001)(83072002)(85852003)(31966008)(59766001)(77982001)(90146001)(46102001)(2656002)(80022001)(79102001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB508;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:192.88.158.215;FPR:7436FF2F.AF907C8A.32E252AD.1CDBEA55.200F3;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > @@ -127,9 +127,27 @@
> >  				VF610_PAD_PTB5__UART1_RX		0x21a1
> >  			>;
> >  		};
> > +
> > +		pinctrl_sai2: sai2grp {
> 
> To sort it alphabetically, the entry should be added before
> pinctrl_uart1.
> 
> > +		      fsl,pins = <
> > +			      VF610_PAD_PTA16__SAI2_TX_BCLK   0x02ed
> > +			      VF610_PAD_PTA18__SAI2_TX_DATA   0x02ee
> > +			      VF610_PAD_PTA19__SAI2_TX_SYNC   0x02ed
> > +			      VF610_PAD_PTA21__SAI2_RX_BCLK   0x02ed
> > +			      VF610_PAD_PTA22__SAI2_RX_DATA   0x02ed
> > +			      VF610_PAD_PTA23__SAI2_RX_SYNC   0x02ed
> > +			      VF610_PAD_PTB18__EXT_AUDIO_MCLK 0x02ed
> 
> Use tabs instead of spaces.
> 
> Shawn
> 

Yes, I'll fix these two issues above.

Thanks,

--
Best Regards,
Xiubo


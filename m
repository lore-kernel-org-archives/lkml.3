Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaAHFDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 00:03:38 -0500
Received: from mail-bn1lp0157.outbound.protection.outlook.com ([207.46.163.157]:22500
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbaAHFD3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 00:03:29 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv9 2/4] ARM: dts: Add Freescale FTM PWM node for VF610.
Thread-Topic: [PATCHv9 2/4] ARM: dts: Add Freescale FTM PWM node for VF610.
Thread-Index: AQHPC4hKZG4esUEnnkSgy0e4nZZTDZp5O1gAgAEKq3A=
Date: Wed, 8 Jan 2014 05:03:26 +0000
Message-ID: <d7b0a9b5bd134ba0a56b6d737bee4c42@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1389082438-2199-1-git-send-email-Li.Xiubo@freescale.com>
 <20140107130557.GI12346@S2101-09.ap.freescale.net>
In-Reply-To: <20140107130557.GI12346@S2101-09.ap.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(164054003)(189002)(199002)(51704005)(66066001)(74706001)(74876001)(77982001)(63696002)(79102001)(59766001)(81816001)(81686001)(65816001)(80022001)(76796001)(76786001)(76576001)(56776001)(85306002)(87266001)(56816005)(90146001)(83072002)(85852003)(87936001)(2656002)(80976001)(19580395003)(83322001)(74316001)(74366001)(53806001)(76482001)(54356001)(4396001)(46102001)(51856001)(49866001)(47736001)(50986001)(47976001)(74502001)(47446002)(31966008)(54316002)(74662001)(81542001)(69226001)(81342001)(33646001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB505;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Has the FTM PWM device tree bindings been accepted/merged?  Please only
> send me DTS changes after that.  Also when you send me the DTS changes,
> please base on imx/dt or for-next branch of my git tree below.
> 
>   git://git.linaro.org/people/shawnguo/linux-2.6.git
> 

Yes, I will resend these dt patches after the FTM driver has been merged
bases on this tree.

Thanks,

Xiubo

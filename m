Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbaCSGHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 02:07:07 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:34509
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751941AbaCSGHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:07:05 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv10 0/4] Add Freescale FTM PWM support
Thread-Topic: [PATCHv10 0/4] Add Freescale FTM PWM support
Thread-Index: AQHPM6kK0236rsYOgkSfLqnsdcRWmprnXcQAgACtPkA=
Date: Wed, 19 Mar 2014 06:07:00 +0000
Message-ID: <14aa9d9e0e874ad4b3f26517e4042986@DM2PR03MB509.namprd03.prod.outlook.com>
References: <1393493992-26073-1-git-send-email-Li.Xiubo@freescale.com>
 <20140318194457.GA5917@mithrandir>
In-Reply-To: <20140318194457.GA5917@mithrandir>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(51704005)(189002)(199002)(164054003)(51856001)(81816001)(74876001)(20776003)(63696002)(74366001)(50986001)(47976001)(87936001)(90146001)(19580395003)(66066001)(56816005)(80022001)(74706001)(83322001)(65816001)(54316002)(56776001)(76482001)(47446002)(74662001)(76796001)(74502001)(76576001)(76786001)(31966008)(80976001)(81342001)(81686001)(53806001)(54356001)(81542001)(74316001)(85306002)(69226001)(85852003)(59766001)(77982001)(93136001)(83072002)(4396001)(79102001)(95666003)(92566001)(87266001)(46102001)(97336001)(33646001)(97186001)(95416001)(93516002)(86362001)(2656002)(47736001)(49866001)(94946001)(94316002)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB511;H:DM2PR03MB509.namprd03.prod.outlook.com;FPR:6AD93E10.A831B3A1.BDD27143.C4E46E93.201AA;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [PATCHv10 0/4] Add Freescale FTM PWM support
> 
> On Thu, Feb 27, 2014 at 05:39:48PM +0800, Xiubo Li wrote:
> > Changed in V10:
> >   Fix some bugs and adjust the code from Thierry's comments.
> >
> >
> > Xiubo Li (4):
> >   pwm: Add Freescale FTM PWM driver support
> >   ARM: dts: vf610: Add Freescale FTM PWM node.
> >   ARM: dts: vf610-twr: Enables FTM PWM device.
> >   Documentation: Add device tree bindings for Freescale FTM PWM.
> >
> >  .../devicetree/bindings/pwm/pwm-fsl-ftm.txt        |  35 ++
> >  arch/arm/boot/dts/vf610-twr.dts                    |   6 +
> >  arch/arm/boot/dts/vf610.dtsi                       |  13 +
> >  drivers/pwm/Kconfig                                |  10 +
> >  drivers/pwm/Makefile                               |   1 +
> >  drivers/pwm/pwm-fsl-ftm.c                          | 496
> +++++++++++++++++++++
> >  6 files changed, 561 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> >  create mode 100644 drivers/pwm/pwm-fsl-ftm.c
> 
> I've applied patches 1 and 4 to the PWM tree, with some minor cosmetic
> fixups that I thought didn't warrant these patches to go through yet
> another revision. =)
> 
> Thanks,
> Thierry

@Thierry,

Great, Thanks very much, 
:)


Best Regards,
Xiubo





Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaBYCZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 21:25:14 -0500
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:28712
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751422AbaBYCZM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 21:25:12 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Subject: RE: [PATCHv9 Resend 0/4] Add Freescale FTM PWM driver
Thread-Topic: [PATCHv9 Resend 0/4] Add Freescale FTM PWM driver
Thread-Index: AQHPLVcK2a4W4I0fkU+aRxqqqXzxxZrFRntA
Date: Tue, 25 Feb 2014 02:25:09 +0000
Message-ID: <beb8e719664148948f31026aaa01fb40@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1392799137-17188-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1392799137-17188-1-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01334458E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(13464003)(377454003)(51704005)(199002)(189002)(74316001)(51856001)(4396001)(74366001)(87266001)(69226001)(87936001)(80022001)(49866001)(81816001)(85852003)(31966008)(81342001)(76482001)(66066001)(65816001)(54316002)(2656002)(47446002)(92566001)(47976001)(85306002)(56776001)(47736001)(59766001)(56816005)(63696002)(90146001)(81542001)(79102001)(50986001)(74662001)(46102001)(77982001)(53806001)(83072002)(54356001)(74502001)(83322001)(93516002)(80976001)(94316002)(74706001)(74876001)(93136001)(86362001)(33646001)(19580405001)(19580395003)(76786001)(76796001)(76576001)(95416001)(81686001)(94946001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB506;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:BA5D3C86.2033BC1E.7D714DE3.5CD68A53.2019C;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thierry, Ping ? :)



> -----Original Message-----
> From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
> Sent: Wednesday, February 19, 2014 4:39 PM
> To: thierry.reding@gmail.com; linux-pwm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Xiubo Li-B47053
> Subject: [PATCHv9 Resend 0/4] Add Freescale FTM PWM driver
> 
> Resend this patch series, just adding the missing and new Reviewed-by and
> Acked-by infomation of this patch series.
> 
> 
> Xiubo Li (4):
>   pwm: Add Freescale FTM PWM driver support
>   ARM: dts: vf610: Add Freescale FTM PWM node.
>   ARM: dts: vf610-twr: Enables FTM PWM device.
>   Documentation: Add device tree bindings for Freescale FTM PWM.
> 
>  .../devicetree/bindings/pwm/pwm-fsl-ftm.txt        |  34 ++
>  arch/arm/boot/dts/vf610-twr.dts                    |   6 +
>  arch/arm/boot/dts/vf610.dtsi                       |  13 +
>  drivers/pwm/Kconfig                                |  10 +
>  drivers/pwm/Makefile                               |   1 +
>  drivers/pwm/pwm-fsl-ftm.c                          | 479
> +++++++++++++++++++++
>  6 files changed, 543 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
>  create mode 100644 drivers/pwm/pwm-fsl-ftm.c
> 
> --
> 1.8.4
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab3LTLar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 06:30:47 -0500
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:21680
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756662Ab3LTLap convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 06:30:45 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        Jingchang Lu <jingchang.lu@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Subject: RE: [PATCHv4 3/4] ARM: dts: Enable SAI ALSA SoC DAI device for
 Vybrid VF610 TOWER board.
Thread-Topic: [PATCHv4 3/4] ARM: dts: Enable SAI ALSA SoC DAI device for
 Vybrid VF610 TOWER board.
Thread-Index: AQHO/SbtfTE4gHYBOUWxURPn3FEtAZpc8tqA
Date: Fri, 20 Dec 2013 11:30:43 +0000
Message-ID: <e130ad7ed4b64bc198d69762edbd8d4b@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1387501387-2151-1-git-send-email-Li.Xiubo@freescale.com>
 <1387501387-2151-3-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1387501387-2151-3-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(199002)(189002)(51704005)(50986001)(33646001)(46102001)(74876001)(74706001)(47736001)(47976001)(49866001)(4396001)(74316001)(74366001)(76482001)(15202345003)(51856001)(53806001)(54356001)(63696002)(81542001)(19580405001)(19580395003)(81342001)(15975445006)(79102001)(54316002)(83322001)(65816001)(80976001)(66066001)(80022001)(81816001)(81686001)(69226001)(31966008)(87266001)(85306002)(74502001)(74662001)(47446002)(85852003)(59766001)(77982001)(87936001)(76576001)(76786001)(76796001)(56776001)(90146001)(83072002)(2656002)(56816005)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB507;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  Could someone help review and merge this DTS patch please ?

  Thanks very much!

Best Regards,
Xiubo



> Subject: [PATCHv4 3/4] ARM: dts: Enable SAI ALSA SoC DAI device for Vybrid
> VF610 TOWER board.
> 
> This patch adds and enables the SAI device.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  arch/arm/boot/dts/vf610-twr.dts | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vf610-twr.dts b/arch/arm/boot/dts/vf610-twr.dts
> index c8047ca..e60c20c 100644
> --- a/arch/arm/boot/dts/vf610-twr.dts
> +++ b/arch/arm/boot/dts/vf610-twr.dts
> @@ -74,6 +74,12 @@
>  	status = "okay";
>  };
> 
> +&sai2 {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_sai2_1>;
> +	status = "okay";
> +};
> +
>  &uart1 {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_uart1_1>;
> --
> 1.8.4
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 


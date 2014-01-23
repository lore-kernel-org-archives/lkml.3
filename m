Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaAWLAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 06:00:22 -0500
Received: from mail-bn1lp0150.outbound.protection.outlook.com ([207.46.163.150]:47079
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbaAWLAU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 06:00:20 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "broonie@linaro.org" <broonie@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Subject: RE: [PATCH] ASoC: simple-card: fix simple card widgets routing
 property name usage
Thread-Topic: [PATCH] ASoC: simple-card: fix simple card widgets routing
 property name usage
Thread-Index: AQHPDcs8kQD2oClG706xXAi/otI9D5qSOExA
Date: Thu, 23 Jan 2014 11:00:16 +0000
Message-ID: <6982194301ae4ee48be60e23dbd79927@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1389331047-21437-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1389331047-21437-1-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.216]
x-forefront-prvs: 0100732B76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(199002)(189002)(81816001)(47976001)(81686001)(76576001)(59766001)(4396001)(87266001)(79102001)(76786001)(47736001)(2201001)(83322001)(85306002)(19580405001)(87936001)(53806001)(56776001)(81342001)(50986001)(81542001)(69226001)(92566001)(49866001)(76796001)(93136001)(65816001)(33646001)(85852003)(74316001)(54356001)(74876001)(90146001)(56816005)(51856001)(47446002)(83072002)(63696002)(76482001)(46102001)(19580395003)(74502001)(2656002)(54316002)(77982001)(74366001)(80976001)(80022001)(86362001)(66066001)(93516002)(74662001)(74706001)(31966008)(94316002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB506;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:192.88.158.216;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like to know the status about this patch.

Thanks very much.

Best Regards,
Xiubo


> Subject: [PATCH] ASoC: simple-card: fix simple card widgets routing property
> name usage
> 
> Fix the usage of simple card widgets routing property, and make it the
> same with simple card routing property name.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  Documentation/devicetree/bindings/sound/simple-card.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/sound/simple-card.txt
> b/Documentation/devicetree/bindings/sound/simple-card.txt
> index e9e20ec..19c84df 100644
> --- a/Documentation/devicetree/bindings/sound/simple-card.txt
> +++ b/Documentation/devicetree/bindings/sound/simple-card.txt
> @@ -43,7 +43,7 @@ Example:
>  sound {
>  	compatible = "simple-audio-card";
>  	simple-audio-card,format = "left_j";
> -	simple-audio-routing =
> +	simple-audio-card,routing =
>  		"MIC_IN", "Mic Jack",
>  		"Headphone Jack", "HP_OUT",
>  		"Ext Spk", "LINE_OUT";
> --
> 1.8.4
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaIZFan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 01:30:43 -0400
Received: from mail-bl2on0129.outbound.protection.outlook.com ([65.55.169.129]:36558
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753792AbaIZFam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 01:30:42 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] ARM: Kconfig: Open force maximum zone order for all SoCs
Thread-Topic: [PATCH] ARM: Kconfig: Open force maximum zone order for all SoCs
Thread-Index: AQHPxaZAuP5rXZmtCUqpf02RzJ7II5wTCh3g
Date: Fri, 26 Sep 2014 05:30:40 +0000
Message-ID: <9dc024498c904d48b3a25430f8d31f29@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409546541-4129-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1409546541-4129-1-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0613;
x-forefront-prvs: 03468CBA43
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(6029001)(164054003)(13464003)(199003)(377454003)(51704005)(189002)(101416001)(108616004)(74316001)(33646002)(2656002)(85852003)(83072002)(87936001)(76576001)(4396001)(10300001)(106356001)(120916001)(99396003)(66066001)(106116001)(105586002)(64706001)(20776003)(2501002)(90102001)(19580405001)(83322001)(76482002)(19580395003)(81542003)(46102003)(95666004)(77982003)(99286002)(80022003)(81342003)(74502003)(21056001)(74662003)(97736003)(79102003)(54356999)(76176999)(77096002)(110136001)(92566001)(85306004)(31966008)(50986999)(2351001)(86362001)(107046002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0613;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

I'd like to know the status of this patch.

Our Platforms depend on it.

Thanks,

BRs
Xiubo

> -----Original Message-----
> From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
> Sent: Monday, September 01, 2014 12:42 PM
> To: linux@arm.linux.org.uk; linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org; Xiubo Li-B47053
> Subject: [PATCH] ARM: Kconfig: Open force maximum zone order for all SoCs
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  arch/arm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index c49a775..bf8445c 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1687,7 +1687,7 @@ config ARCH_WANT_GENERAL_HUGETLB
>  source "mm/Kconfig"
> 
>  config FORCE_MAX_ZONEORDER
> -	int "Maximum zone order" if ARCH_SHMOBILE_LEGACY
> +	int "Maximum zone order"
>  	range 11 64 if ARCH_SHMOBILE_LEGACY
>  	default "12" if SOC_AM33XX
>  	default "9" if SA1111 || ARCH_EFM32
> --
> 1.8.4


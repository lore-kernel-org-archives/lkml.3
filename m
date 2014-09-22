Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaIVKLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 06:11:34 -0400
Received: from mail-bl2on0107.outbound.protection.outlook.com ([65.55.169.107]:7110
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751270AbaIVKLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:11:33 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "vikas.sajjan@samsung.com" <vikas.sajjan@samsung.com>,
        "joshi@samsung.com" <joshi@samsung.com>,
        "naushad@samsung.com" <naushad@samsung.com>,
        "thomas.ab@samsung.com" <thomas.ab@samsung.com>,
        "chow.kim@samsung.com" <chow.kim@samsung.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "Aisheng.Dong@freescale.com" <Aisheng.Dong@freescale.com>
Subject: RE: [PATCH v5] mfd: syscon: Decouple syscon interface from platform
 devices
Thread-Topic: [PATCH v5] mfd: syscon: Decouple syscon interface from platform
 devices
Thread-Index: AQHP1h/7kun2+wSlOUaNMEdBanKlXpwM6dUA
Date: Mon, 22 Sep 2014 09:55:36 +0000
Message-ID: <d986e3e3ea4d410ea3dab7483c89d640@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1411360807-7750-1-git-send-email-pankaj.dubey@samsung.com>
In-Reply-To: <1411360807-7750-1-git-send-email-pankaj.dubey@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 034215E98F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(164054003)(189002)(199003)(79102003)(76482002)(46102003)(77982003)(101416001)(31966008)(81342003)(81542003)(80022003)(74662003)(74502003)(120916001)(20776003)(97736003)(66066001)(64706001)(106356001)(107046002)(106116001)(108616004)(83322001)(85306004)(77096002)(95666004)(74316001)(76576001)(105586002)(86362001)(4396001)(99286002)(21056001)(85852003)(2656002)(83072002)(50986999)(92566001)(54356999)(76176999)(90102001)(33646002)(87936001)(99396002)(2201001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB324;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[...]
> +static struct regmap_config syscon_regmap_config = {
> +	.reg_bits = 32,
> +	.val_bits = 32,
> +	.reg_stride = 4,
>  };
> 
> -static int syscon_match_node(struct device *dev, void *data)
> +static struct syscon *of_syscon_register(struct device_node *np)
>  {
> -	struct device_node *dn = data;
> +	struct platform_device *pdev = NULL;

struct platform_device *pdev; ?

Thanks,

BRs
Xiubo


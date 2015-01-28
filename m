Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609AbbA1Bd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:33:27 -0500
Received: from mail-bn1on0111.outbound.protection.outlook.com ([157.56.110.111]:27296
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760170AbbA1BdY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:33:24 -0500
From: "fugang.duan@freescale.com" <fugang.duan@freescale.com>
To: Stefan Agner <stefan@agner.ch>, "jic23@kernel.org" <jic23@kernel.org>
CC: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "maitysanchayan@gmail.com" <maitysanchayan@gmail.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/3] iio: adc: vf610: respect ADC clocking limitations
Thread-Topic: [PATCH 0/3] iio: adc: vf610: respect ADC clocking limitations
Thread-Index: AQHQNMpz11oolv30ikCxc43tvujT8JzUyoZw
Date: Wed, 28 Jan 2015 01:33:16 +0000
Message-ID: <BLUPR03MB37366EC9DAB3A4B0A16E72BF5330@BLUPR03MB373.namprd03.prod.outlook.com>
References: <1421769723-28677-1-git-send-email-stefan@agner.ch>
In-Reply-To: <1421769723-28677-1-git-send-email-stefan@agner.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.51]
authentication-results: agner.ch; dkim=none (message not signed)
 header.d=none;agner.ch; dmarc=none action=none header.from=freescale.com;
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BLUPR03MB375;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB375;
x-forefront-prvs: 047001DADA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(51704005)(46102003)(2900100001)(2950100001)(33656002)(40100003)(99286002)(2501002)(102836002)(77096005)(122556002)(77156002)(86362001)(19580395003)(19580405001)(92566002)(2656002)(87936001)(66066001)(76176999)(50986999)(54606007)(54206007)(106116001)(62966003)(54356999)(76576001)(74316001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB375;H:BLUPR03MB373.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2015 01:33:16.2251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR03MB375
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Agner <stefan@agner.ch> Sent: Wednesday, January 21, 2015 12:02 AM
> To: jic23@kernel.org
> Cc: shawn.guo@linaro.org; Duan Fugang-B38611; maitysanchayan@gmail.com;
> linux-iio@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; stefan@agner.ch
> Subject: [PATCH 0/3] iio: adc: vf610: respect ADC clocking limitations
> 
> Respect ADC clocking limitations which lead to bogous reading on 500MHz
> clocked Vybrid SoC's. Additionally, also implement a sysfs-property to
> configure the conversion mode available in this ADC peripherial.
> 
> Stefan Agner (3):
>   iio: adc: vf610: use ADC clock within specification
>   iio: adc: vf610: implement configurable conversion modes
>   ARM: dts: add property for maximum ADC clock frequencies
> 
>  .../devicetree/bindings/iio/adc/vf610-adc.txt      |   9 ++
>  arch/arm/boot/dts/vfxxx.dtsi                       |   4 +
>  drivers/iio/adc/vf610_adc.c                        | 175
> +++++++++++++++++----
>  3 files changed, 156 insertions(+), 32 deletions(-)
> 
> --
> 2.2.2

The patch set are fine for me.

Acked-by: Fugang Duan <B38611@freescale.com>

Thanks. 
Fugang

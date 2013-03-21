Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab3CUDVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 23:21:50 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:40843
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754806Ab3CUDVs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 23:21:48 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275dh8275bhz2dh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1b0ah1155h)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>, Bob Liu <lliubbo@gmail.com>
CC: "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 20 Mar 2013 23:21:36 -0400
Subject: RE: [PATCH] blackfin: twi: Remove bogus #endif
Thread-Topic: [PATCH] blackfin: twi: Remove bogus #endif
Thread-Index: Ac4lS4ku9EDyj0hWQjajIC5xHIwnUQAl44JA
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D173FF57E18D@NWD2CMBX1.ad.analog.com>
References: <1363770951-28158-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1363770951-28158-1-git-send-email-geert@linux-m68k.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Sonic Zhang<sonic.zhang@analog.com>

>-----Original Message-----
>From: Geert Uytterhoeven [mailto:geert@linux-m68k.org]
>Sent: Wednesday, March 20, 2013 5:16 PM
>To: Zhang, Sonic; Bob Liu
>Cc: uclinux-dist-devel@blackfin.uclinux.org; linux-kernel@vger.kernel.org; Geert
>Uytterhoeven
>Subject: [PATCH] blackfin: twi: Remove bogus #endif
>
>arch/blackfin/mach-bf538/boards/ezkit.c:768:2: error: #endif without #if
>
>Introduced by commit cf93feb3a0dee97c7896016a352a3226139fbcf4 ("blackfin:
>twi: Move TWI peripheral pin request array to platform data"), which removed the
>#if, but forgot about the #endif.
>
>Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>---
>http://kisskb.ellerman.id.au/kisskb/buildresult/8427477/
>
> arch/blackfin/mach-bf538/boards/ezkit.c |    1 -
> 1 files changed, 0 insertions(+), 1 deletions(-)
>
>diff --git a/arch/blackfin/mach-bf538/boards/ezkit.c b/arch/blackfin/mach-
>bf538/boards/ezkit.c
>index a4fce03..755f0dc 100644
>--- a/arch/blackfin/mach-bf538/boards/ezkit.c
>+++ b/arch/blackfin/mach-bf538/boards/ezkit.c
>@@ -764,7 +764,6 @@ static struct platform_device i2c_bfin_twi1_device = {
>       .num_resources = ARRAY_SIZE(bfin_twi1_resource),
>       .resource = bfin_twi1_resource,
> };
>-#endif        /* CONFIG_BF542 */
> #endif        /* CONFIG_I2C_BLACKFIN_TWI */
>
> #if defined(CONFIG_KEYBOARD_GPIO) ||
>defined(CONFIG_KEYBOARD_GPIO_MODULE)
>--
>1.7.0.4
>



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab3ANCSY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 21:18:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:23250 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab3ANCSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 21:18:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,465,1355126400"; 
   d="scan'208";a="246135490"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>
Subject: RE: [PATCH] mfd, TWL4030: TWL4030 need select REGMAP_I2C
Thread-Topic: [PATCH] mfd, TWL4030: TWL4030 need select REGMAP_I2C
Thread-Index: AQHN5z4cEjBF4U1C/UWbAzF3dkdU0ZhIK6Iw
Date: Mon, 14 Jan 2013 02:18:04 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A203154@SHSMSX101.ccr.corp.intel.com>
References: <1356358796.1688.3.camel@cliu38-desktop-build>
 <50E162F8.8030403@ti.com>
In-Reply-To: <50E162F8.8030403@ti.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0E2IWQA030110

Hi maintainers,

Could you help to push this patch?
Every time syncing the latest code, always meet this build error.
Sorry to disturb.

> -----Original Message-----
> From: Peter Ujfalusi [mailto:peter.ujfalusi@ti.com]
> Sent: Monday, December 31, 2012 6:04 PM
> To: Liu, Chuansheng
> Cc: sameo@linux.intel.com; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] mfd, TWL4030: TWL4030 need select REGMAP_I2C
> 
> On 12/24/2012 03:19 PM, Chuansheng Liu wrote:
> > This patch fix the below build error:
> > drivers/built-in.o: In function `twl_probe':
> > drivers/mfd/twl-core.c:1256: undefined reference to `devm_regmap_init_i2c'
> > make: *** [vmlinux] Error 1
> 
> Thanks Liu, I have missed this one.
> 
> Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> 
> >
> > Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> > ---
> >  drivers/mfd/Kconfig |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > index 1c0abd4..47ad4e2 100644
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -292,6 +292,7 @@ config TWL4030_CORE
> >  	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0
> Support"
> >  	depends on I2C=y && GENERIC_HARDIRQS
> >  	select IRQ_DOMAIN
> > +	select REGMAP_I2C
> >  	help
> >  	  Say yes here if you have TWL4030 / TWL6030 family chip on your board.
> >  	  This core driver provides register access and IRQ handling
> >
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

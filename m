Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673Ab3DBFuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 01:50:06 -0400
Received: from nasmtp02.atmel.com ([204.2.163.16]:44999 "EHLO
	nasmtp02.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760042Ab3DBFuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 01:50:04 -0400
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "richard.genoud@gmail.com" <richard.genoud@gmail.com>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "Lin, JM" <JM.Lin@atmel.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v7 03/14] spi/spi-atmel: add physical base address
Thread-Topic: [PATCH v7 03/14] spi/spi-atmel: add physical base address
Thread-Index: AQHOJHXx8mQi9R5DskWA68i2eZE0h5jA7keAgAGT0mA=
Date: Tue, 2 Apr 2013 05:49:50 +0000
Message-ID: <B256D81BAE5131468A838E5D7A24364150E8B33C@penmbx01>
References: <1363678866-3567-1-git-send-email-wenyou.yang@atmel.com>
 <1363679016-3761-1-git-send-email-wenyou.yang@atmel.com>
 <20130401134147.GV18636@opensource.wolfsonmicro.com>
In-Reply-To: <20130401134147.GV18636@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r325o940015432

Hi, Mark,

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: 2013Äê4ÔÂ1ÈÕ 21:42
> To: Yang, Wenyou
> Cc: linux-arm-kernel@lists.infradead.org; grant.likely@secretlab.ca;
> richard.genoud@gmail.com; plagnioj@jcrosoft.com; Ferre, Nicolas; Lin, JM;
> spi-devel-general@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v7 03/14] spi/spi-atmel: add physical base address
> 
> On Tue, Mar 19, 2013 at 03:43:36PM +0800, Wenyou Yang wrote:
> 
> > +++ b/drivers/spi/spi-atmel.c
> > @@ -196,6 +196,7 @@ struct atmel_spi_caps {  struct atmel_spi {
> >  	spinlock_t		lock;
> >
> > +	resource_size_t		phybase;
> >  	void __iomem		*regs;
> >  	int			irq;
> >  	struct clk		*clk;
> 
> This looks like the wrong type?

I double checked.

The type ' resource_size_t ' is defined in include/linux/ types.h as below,

typedef phys_addr_t resource_size_t;

I think it is OK.

Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

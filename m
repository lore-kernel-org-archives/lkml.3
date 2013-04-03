Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761668Ab3DCFKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 01:10:33 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:29762 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761625Ab3DCFKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 01:10:31 -0400
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
Subject: RE: [PATCH v7 06/14] spi/spi-atmel: add flag to controller data for
 lock operations
Thread-Topic: [PATCH v7 06/14] spi/spi-atmel: add flag to controller data
 for lock operations
Thread-Index: AQHOJHZIj9hcRKjFiU2tm/F1XXDcQJjA74OAgAMZ8tA=
Date: Wed, 3 Apr 2013 05:09:53 +0000
Message-ID: <B256D81BAE5131468A838E5D7A24364150E8CC7B@penmbx01>
References: <1363678866-3567-1-git-send-email-wenyou.yang@atmel.com>
 <1363679163-3897-1-git-send-email-wenyou.yang@atmel.com>
 <20130401134613.GY18636@opensource.wolfsonmicro.com>
In-Reply-To: <20130401134613.GY18636@opensource.wolfsonmicro.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r335Aa8n025484

Hi, Mark,

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: 2013Äê4ÔÂ1ÈÕ 21:46
> To: Yang, Wenyou
> Cc: linux-arm-kernel@lists.infradead.org; grant.likely@secretlab.ca;
> richard.genoud@gmail.com; plagnioj@jcrosoft.com; Ferre, Nicolas; Lin, JM;
> spi-devel-general@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v7 06/14] spi/spi-atmel: add flag to controller data for lock
> operations
> 
> On Tue, Mar 19, 2013 at 03:46:03PM +0800, Wenyou Yang wrote:
> 
> > +static void atmel_spi_lock(struct atmel_spi *as) {
> > +		spin_lock_irqsave(&as->lock, as->flags); }
> 
> Coding style.
I will change it in next version.

> 
> > -	spin_unlock(&as->lock);
> > +	atmel_spi_unlock(as);
> >  	msg->complete(msg->context);
> > -	spin_lock(&as->lock);
> > +	atmel_spi_lock(as);
> 
> This replaces non-irqsave versions with irqsave versions of the lock.
> Is this safe/correct?  If it is I'd have expected some sort of mention of it in the
> commit log.
I will add some commit log.

Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

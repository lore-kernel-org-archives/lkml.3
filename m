Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760647Ab3DBFrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 01:47:16 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:51614 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760605Ab3DBFrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 01:47:15 -0400
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
Subject: RE: [PATCH v7 10/14] spi/spi-atmel: correct 16 bits transfers with
 DMA
Thread-Topic: [PATCH v7 10/14] spi/spi-atmel: correct 16 bits transfers with
 DMA
Thread-Index: AQHOJHaxQs/SML/7SEOeFaTON5hcTZjA8a6AgAGQGgA=
Date: Tue, 2 Apr 2013 05:46:50 +0000
Message-ID: <B256D81BAE5131468A838E5D7A24364150E8B304@penmbx01>
References: <1363678866-3567-1-git-send-email-wenyou.yang@atmel.com>
 <1363679341-4087-1-git-send-email-wenyou.yang@atmel.com>
 <20130401135359.GB18636@opensource.wolfsonmicro.com>
In-Reply-To: <20130401135359.GB18636@opensource.wolfsonmicro.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r325lF0l015413

Hi, Mark,

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: 2013Äê4ÔÂ1ÈÕ 21:54
> To: Yang, Wenyou
> Cc: linux-arm-kernel@lists.infradead.org; grant.likely@secretlab.ca;
> richard.genoud@gmail.com; plagnioj@jcrosoft.com; Ferre, Nicolas; Lin, JM;
> spi-devel-general@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v7 10/14] spi/spi-atmel: correct 16 bits transfers with DMA
> 
> On Tue, Mar 19, 2013 at 03:49:01PM +0800, Wenyou Yang wrote:
> > From: Richard Genoud <richard.genoud@gmail.com>
> >
> > Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> > Cc: spi-devel-general@lists.sourceforge.net
> > Cc: linux-kernel@vger.kernel.org
> > [wenyou.yang@atmel.com: submit the patch]
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> 
> Shouldn't this be squashed into the dmaengine patch?
OK, I will squash it into the dmaengine patch

Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

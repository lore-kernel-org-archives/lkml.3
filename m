Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589Ab3DBFqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 01:46:20 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:51426 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759398Ab3DBFqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 01:46:19 -0400
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
Subject: RE: [PATCH v7 08/14] spi/spi-atmel: fix spi-atmel driver to adapt
 to slave_config changes
Thread-Topic: [PATCH v7 08/14] spi/spi-atmel: fix spi-atmel driver to adapt
 to slave_config changes
Thread-Index: AQHOJHZ4XYMPApy8HEK0K/M7YbB+ZJjA8N4AgAGPfxA=
Date: Tue, 2 Apr 2013 05:45:48 +0000
Message-ID: <B256D81BAE5131468A838E5D7A24364150E8A2ED@penmbx01>
References: <1363678866-3567-1-git-send-email-wenyou.yang@atmel.com>
 <1363679236-3973-1-git-send-email-wenyou.yang@atmel.com>
 <20130401135104.GZ18636@opensource.wolfsonmicro.com>
In-Reply-To: <20130401135104.GZ18636@opensource.wolfsonmicro.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r325kNN3015406

Hi, Mark,

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: 2013Äê4ÔÂ1ÈÕ 21:51
> To: Yang, Wenyou
> Cc: linux-arm-kernel@lists.infradead.org; grant.likely@secretlab.ca;
> richard.genoud@gmail.com; plagnioj@jcrosoft.com; Ferre, Nicolas; Lin, JM;
> spi-devel-general@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v7 08/14] spi/spi-atmel: fix spi-atmel driver to adapt to
> slave_config changes
> 
> On Tue, Mar 19, 2013 at 03:47:16PM +0800, Wenyou Yang wrote:
> > From: Richard Genoud <richard.genoud@gmail.com>
> >
> > This is the following of the patch
> > e2b35f3dbfc080f15b72834d08f04f0269dbe9be
> 
> What is this patch actually doing, shouldn't it be part of the previous commit?
> The changelog really ought to have a plain text version of the commit
> description too.
You are right, it isn't the part of the previous commit.
I will squash it into the dmaengine patch.

Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

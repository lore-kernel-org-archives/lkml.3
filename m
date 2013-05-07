Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab3EGBLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:11:31 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:10151 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab3EGBL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:11:29 -0400
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Mark Brown <broonie@kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Grant Likely <grant.likely@linaro.org>,
        Richard Genoud <richard.genoud@gmail.com>,
        "Joachim Eastwood" <manabian@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "Lin, JM" <JM.Lin@atmel.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 01/16] spi/spi-atmel: fix probing failure after
 xfer->speed_hz set
Thread-Topic: [PATCH v6 01/16] spi/spi-atmel: fix probing failure after
 xfer->speed_hz set
Thread-Index: AQHOGuP8IM96tyzK7E6aJ9clb/yCNJiZo0mAgFfg7JD//9lbgIAAJ+qAgAZIQYCAAXeLgA==
Date: Tue, 7 May 2013 01:11:17 +0000
Message-ID: <B256D81BAE5131468A838E5D7A24364154238AF5@penmbx02>
References: <1362626715-6549-1-git-send-email-wenyou.yang@atmel.com>
 <1362626815-6628-1-git-send-email-wenyou.yang@atmel.com>
 <CAGhQ9VwW18LXY5Jn0FUFCaAzKxP1W3QADG=JBp9JbgaAwo=F2Q@mail.gmail.com>
 <B256D81BAE5131468A838E5D7A24364154236AB5@penmbx02>
 <CACQ1gAhZO3stjrwf5SiZf7jOO8T5bAJZiz97M7+7vwFmk2e65g@mail.gmail.com>
 <5182414F.1000201@atmel.com>
 <20130506103105.GB13472@opensource.wolfsonmicro.com>
In-Reply-To: <20130506103105.GB13472@opensource.wolfsonmicro.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r471BtNt029934

Hi, Mark

> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: 2013Äê5ÔÂ6ÈÕ 18:31
> To: Ferre, Nicolas
> Cc: grant.likely@secretlab.ca; Grant Likely; Richard Genoud; Yang, Wenyou;
> Joachim Eastwood; linux-arm-kernel@lists.infradead.org;
> plagnioj@jcrosoft.com; Lin, JM; spi-devel-general@lists.sourceforge.net;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v6 01/16] spi/spi-atmel: fix probing failure after
> xfer->speed_hz set
> 
> On Thu, May 02, 2013 at 12:34:55PM +0200, Nicolas Ferre wrote:
> 
> > Can you tell us if this SPI patch will be merged upstream using one of
> > your paths?
> 
> I have no idea what patch this is but if it's not in my tree -next it's unlikely to be
> merged.
This is dropped patch, no need to be merged.

We tested Atmel spi in your tree-next , but it doesn't work, the reason is the Joachim Eastwood's patch is not included. 
https://patchwork.kernel.org/patch/2165301/
which Joachim said that Grant said he applied.

Thanks

Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

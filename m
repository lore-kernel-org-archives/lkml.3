Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab3CHJn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 04:43:58 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:47648 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab3CHJnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 04:43:55 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "richard.genoud@gmail.com" <richard.genoud@gmail.com>,
        "Lin, JM" <JM.Lin@atmel.com>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>
Subject: RE: [PATCH v6 01/16] spi/spi-atmel: fix probing failure after
 xfer->speed_hz set
Thread-Topic: [PATCH v6 01/16] spi/spi-atmel: fix probing failure after
 xfer->speed_hz set
Thread-Index: AQHOGuP8IM96tyzK7E6aJ9clb/yCNJiZn7aAgAHkkTA=
Date: Fri, 8 Mar 2013 09:43:49 +0000
Message-ID: <B256D81BAE5131468A838E5D7A24364149720050@penmbx02>
References: <1362626715-6549-1-git-send-email-wenyou.yang@atmel.com>
 <1362626815-6628-1-git-send-email-wenyou.yang@atmel.com>
 <51388575.4050506@cogentembedded.com>
In-Reply-To: <51388575.4050506@cogentembedded.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r289i18Q027764

Hi, Serqei,

> -----Original Message-----
> From: Sergei Shtylyov [mailto:sergei.shtylyov@cogentembedded.com]
> Sent: 2013Äê3ÔÂ7ÈÕ 20:18
> To: Yang, Wenyou
> Cc: linux-arm-kernel@lists.infradead.org; richard.genoud@gmail.com; Lin, JM;
> Ferre, Nicolas; linux-kernel@vger.kernel.org; grant.likely@secretlab.ca;
> spi-devel-general@lists.sourceforge.net; plagnioj@jcrosoft.com
> Subject: Re: [PATCH v6 01/16] spi/spi-atmel: fix probing failure after
> xfer->speed_hz set
> 
> Hello.
> 
> On 07-03-2013 7:26, Wenyou Yang wrote:
> 
> > commit: 059b8ffeee5b427949872bb6ed5db5ae0788054e
> 
>     Please also specify the summary line of that commit in parens (or however
> you like).
Thanks for your suggestion.

> 
> > cause the atmel spi probing failure.
> 
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > Cc: spi-devel-general@lists.sourceforge.net
> > Cc: linux-kernel@vger.kernel.org
> 
> WBR, Sergei

Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

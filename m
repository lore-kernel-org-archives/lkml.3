Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab3EXHOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 03:14:48 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:19080 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab3EXHOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 03:14:47 -0400
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux@maxim.org.za" <linux@maxim.org.za>
Subject: RE: [PATCH] ARM: at91: Fix: Change internal SRAM memory type to
	"MT_MEMORY_SO"
Thread-Topic: [PATCH] ARM: at91: Fix: Change internal SRAM memory type to
	"MT_MEMORY_SO"
Thread-Index: AQHOVoFuzDkEomPIvUCuWrVoFTdpRZkTy4JA
Date: Fri, 24 May 2013 07:11:04 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641687BB93C@penmbx01>
References: <1369011911-21282-1-git-send-email-wenyou.yang@atmel.com>
 <1369011979-21354-1-git-send-email-wenyou.yang@atmel.com>
 <20130522001457.GA18614@n2100.arm.linux.org.uk>
In-Reply-To: <20130522001457.GA18614@n2100.arm.linux.org.uk>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4O7EqDv009768



> -----Original Message-----
> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> Sent: 2013Äê5ÔÂ22ÈÕ 8:15
> To: Yang, Wenyou
> Cc: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> plagnioj@jcrosoft.com; Ferre, Nicolas; linux@maxim.org.za
> Subject: Re: [PATCH] ARM: at91: Fix: Change internal SRAM memory type to
> "MT_MEMORY_SO"
> 
> On Mon, May 20, 2013 at 09:06:19AM +0800, Wenyou Yang wrote:
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> 
> This needs more of a description.  Also, for a single patch, it's silly
> to send two mails, the first being a cover which has a little more
> information in it about the patch than the patch itself.
> 
> You need to explain _why_ you're making this change.  What I want to see
> is that you've thought about the implications of this - particularly that
> you know that strongly ordered memory does *not* imply any ordering with
> any other memory types.
> 
> In other words, I want to know that this change is not a bodge but there's
> a real reason behind it.
The story is: for sama5d3x with Cortex-A5 core, if not so, when copying code snippet to the internal SRAM, then jump to run this code, but fail to run.
So, refer to other code(such as omap4), do such change. I also test it on at91sam9 with 926ej-s core.
As what you said, I am digging it. Thank you very much.

Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

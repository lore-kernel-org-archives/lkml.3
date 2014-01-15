Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaAOI0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 03:26:50 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43616 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751719AbaAOI0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 03:26:47 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 15 Jan 2014 00:26:43 -0800
Subject: RE: [PATCH] gpio: pxa: normalize the return value for gpio_get
Thread-Topic: [PATCH] gpio: pxa: normalize the return value for gpio_get
Thread-Index: Ac8Rx4AXSzDLBBLlRp+5uoI5hoCaVwAA/vFA
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE540C390509@SC-VEXCH4.marvell.com>
References: <1389333783-3372-1-git-send-email-zhangwm@marvell.com>
 <CACRpkda=4AhOWDYu7ENcovTo_+oSKKVU+eqkHD9W-3bDMv2MUQ@mail.gmail.com>
In-Reply-To: <CACRpkda=4AhOWDYu7ENcovTo_+oSKKVU+eqkHD9W-3bDMv2MUQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-15_02:2014-01-14,2014-01-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1401150001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0F8QtaC007218


> -----Original Message-----
> From: Linus Walleij [mailto:linus.walleij@linaro.org]
> Sent: 2014Äê1ÔÂ15ÈÕ 15:58
> To: Neil Zhang
> Cc: Alexandre Courbot; linux-gpio@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] gpio: pxa: normalize the return value for gpio_get
> 
> On Fri, Jan 10, 2014 at 7:03 AM, Neil Zhang <zhangwm@marvell.com> wrote:
> 
> > It would be convenient to normalize the return value for gpio_get.
> >
> > I have checked mach-mmp / mach-pxa / plat-pxa / plat-orion / mach-orion5x.
> > It's OK for all of them to change this function to return 0 and 1.
> >
> > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> 
> Bah I updated the commit message a bit ... you dropped the
> gpio: pxa: etc from the previous patch, not good but don't worry I fixed it up.
> 
Thanks!

> Yours,
> Linus Walleij

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

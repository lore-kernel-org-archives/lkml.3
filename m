Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab3LMFgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 00:36:20 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11939 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746Ab3LMFgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 00:36:18 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: Neil Zhang <zhangwm@marvell.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 12 Dec 2013 21:36:02 -0800
Subject: RE: [PATCH v3] irqchip: mmp: avoid use head file in a specific arch
Thread-Topic: [PATCH v3] irqchip: mmp: avoid use head file in a specific arch
Thread-Index: Ac7ycHa4RrZSN0MjSPqOLZTJ4tymYgFVJwOQ
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE4F8E3166DD@SC-VEXCH4.marvell.com>
References: <1386326807-21688-1-git-send-email-zhangwm@marvell.com>
In-Reply-To: <1386326807-21688-1-git-send-email-zhangwm@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2013-12-13_02:2013-12-13,2013-12-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1312120220
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBD5aPeH007639

Thomas,

> -----Original Message-----
> From: Neil Zhang [mailto:zhangwm@marvell.com]
> Sent: 2013Äê12ÔÂ6ÈÕ 18:47
> To: tglx@linutronix.de; haojian.zhuang@gmail.com;
> linux-kernel@vger.kernel.org
> Cc: Neil Zhang
> Subject: [PATCH v3] irqchip: mmp: avoid use head file in a specific arch
> 
> For example, arm64 doesn't have mach/irq.h.
> 
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
> ---
>  drivers/irqchip/irq-mmp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/irqchip/irq-mmp.c b/drivers/irqchip/irq-mmp.c index
> 2cb7cd0..470c5de 100644
> --- a/drivers/irqchip/irq-mmp.c
> +++ b/drivers/irqchip/irq-mmp.c
> @@ -22,7 +22,7 @@
>  #include <linux/of_irq.h>
> 
>  #include <asm/exception.h>
> -#include <asm/mach/irq.h>
> +#include <asm/hardirq.h>
> 
>  #include "irqchip.h"
> 
> --
> 1.7.9.5

Ping?

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

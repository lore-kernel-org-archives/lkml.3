Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbaC1BNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 21:13:54 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:24231 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756172AbaC1BNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 21:13:52 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: John Stultz <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 27 Mar 2014 18:13:43 -0700
Subject: RE: [PATCH] timekeeping: check params before use them
Thread-Topic: [PATCH] timekeeping: check params before use them
Thread-Index: Ac9J4bBpH7HQS594S5CkSzb8R/2JeQAQRRGw
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE550559A223@SC-VEXCH4.marvell.com>
References: <1395907978-6202-1-git-send-email-zhangwm@marvell.com>
 <53345F40.70608@linaro.org>
In-Reply-To: <53345F40.70608@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-27_07:2014-03-27,2014-03-27,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1403270144
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2S1E2Rq009295




> -----Original Message-----
> From: John Stultz [mailto:john.stultz@linaro.org]
> Sent: 2014Äê3ÔÂ28ÈÕ 1:26
> To: Neil Zhang; tglx@linutronix.de
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] timekeeping: check params before use them
> 
> On 03/27/2014 01:12 AM, Neil Zhang wrote:
> > Sometimes we won't need all the information from
> > get_xtime_and_monotonic_and_sleep_offset(),
> > so let's check the params before assign the value to them.
> 
> So I think the single in-kernel user of this function does use all of the
> information.
> 
> Can you expand on how your using this and why the extra conditionals are
> worth while?
> 

Please refer to my another patch.
printk: add sleep time into timestamp

I want to add sleep time into printk's timestamp.

> thanks
> -john

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

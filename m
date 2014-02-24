Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaBXMmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 07:42:49 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58193 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543AbaBXMms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 07:42:48 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: Matthieu CASTET <matthieu.castet@parrot.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 24 Feb 2014 04:42:40 -0800
Subject: RE: [PATCH 0/6] bug fix for mv_udc_core.c
Thread-Topic: [PATCH 0/6] bug fix for mv_udc_core.c
Thread-Index: Ac8xS6ZLrDzWxAnlSpiemfXgqMnArgAEggng
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE54EC4133CD@SC-VEXCH4.marvell.com>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
 <20140224113153.64c5a772@parrot.com>
In-Reply-To: <20140224113153.64c5a772@parrot.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-23_03:2014-02-21,2014-02-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1402240045
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1OCgsA6014253


> -----Original Message-----
> From: Matthieu CASTET [mailto:matthieu.castet@parrot.com]
> Sent: 2014Äê2ÔÂ24ÈÕ 18:32
> To: Neil Zhang
> Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 0/6] bug fix for mv_udc_core.c
> 
> Le Mon, 24 Feb 2014 16:03:10 +0800,
> Neil Zhang <zhangwm@marvell.com> a ¨¦crit :
> 
> > This patch set is mainly for bug fix.
> >
> > Neil Zhang (6):
> >   usb: gadget: mv_udc: remove redundant pull up in udc_start
> >   usb: gadget: mv_udc: disable HW zlt for ep0
> >   usb: gadget: mv_udc: clear corresponding interrupt when flush fifo
> >   usb: gadget: mv_udc: check endpoint before queue dtd
> >   USB: gadget: mv_udc: workaroud for missing dTD
> >   USB: gadget: mv_udc: fix corner case for missiong dTD
> >
> >  drivers/usb/gadget/mv_udc_core.c |   47
> ++++++++++++++++++++++++++++++++++----
> >  1 file changed, 42 insertions(+), 5 deletions(-)
> >
> 
> Do you have plan to move to the chipidea udc driver ?
> 
> You could have some bug fix for free or share your bug fix with others.
> 


Not yet.
Will estimate it later.
> 
> Matthieu

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

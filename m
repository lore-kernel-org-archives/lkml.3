Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaBYHSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:18:51 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59472 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707AbaBYHSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:18:50 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: Peter Chen <peter.chen@freescale.com>
CC: Matthieu CASTET <matthieu.castet@parrot.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 24 Feb 2014 23:18:44 -0800
Subject: RE: [PATCH 0/6] bug fix for mv_udc_core.c
Thread-Topic: [PATCH 0/6] bug fix for mv_udc_core.c
Thread-Index: Ac8x6DQmIunpx4o4TVuZaBRhrRe4IAAEXAng
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE54EC4135A8@SC-VEXCH4.marvell.com>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
 <20140224113153.64c5a772@parrot.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC4133CD@SC-VEXCH4.marvell.com>
 <20140225041730.GA14793@shlinux1.ap.freescale.net>
In-Reply-To: <20140225041730.GA14793@shlinux1.ap.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-25_01:2014-02-25,2014-02-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1402240224
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1P7Iu78020432


> -----Original Message-----
> From: Peter Chen [mailto:peter.chen@freescale.com]
> Sent: 2014å¹´2æœˆ25æ—¥ 12:18
> To: Neil Zhang
> Cc: Matthieu CASTET; balbi@ti.com; gregkh@linuxfoundation.org;
> linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 0/6] bug fix for mv_udc_core.c
> 
> On Mon, Feb 24, 2014 at 04:42:40AM -0800, Neil Zhang wrote:
> >
> > > -----Original Message-----
> > > From: Matthieu CASTET [mailto:matthieu.castet@parrot.com]
> > > Sent: 2014å¹´2æœˆ24æ—¥ 18:32
> > > To: Neil Zhang
> > > Cc: balbi@ti.com; gregkh@linuxfoundation.org;
> > > linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH 0/6] bug fix for mv_udc_core.c
> > >
> > > Le Mon, 24 Feb 2014 16:03:10 +0800,
> > > Neil Zhang <zhangwm@marvell.com> a Ã©crit :
> > >
> > > > This patch set is mainly for bug fix.
> > > >
> > > > Neil Zhang (6):
> > > >   usb: gadget: mv_udc: remove redundant pull up in udc_start
> > > >   usb: gadget: mv_udc: disable HW zlt for ep0
> > > >   usb: gadget: mv_udc: clear corresponding interrupt when flush fifo
> > > >   usb: gadget: mv_udc: check endpoint before queue dtd
> > > >   USB: gadget: mv_udc: workaroud for missing dTD
> > > >   USB: gadget: mv_udc: fix corner case for missiong dTD
> > > >
> > > >  drivers/usb/gadget/mv_udc_core.c |   47
> > > ++++++++++++++++++++++++++++++++++----
> > > >  1 file changed, 42 insertions(+), 5 deletions(-)
> > > >
> > >
> > > Do you have plan to move to the chipidea udc driver ?
> > >
> > > You could have some bug fix for free or share your bug fix with others.
> > >
> >
> >
> > Not yet.
> > Will estimate it later.
> > >
> 
> Freescale uses mv udc driver at u-boot, so the chipidea IP should be
> compatible for two SoCs , both Intel and msm are using chipidea driver at linux
> kernel, it should be not difficult for marvell to use it.
> 
> For this patchset, some of them may already be fixed at chipidea driver (3/6,
> 4/6), some of them may not (5/6, 6/6).
> 
> --

Thanks for the comments.
Since we are using it in our product, so it's not that easy to switch to a new driver.

> 
> Best Regards,
> Peter Chen

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

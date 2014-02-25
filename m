Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750993AbaBYHLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:11:46 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6626 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750706AbaBYHLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:11:45 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: Peter Chen <Peter.Chen@freescale.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 24 Feb 2014 23:11:39 -0800
Subject: RE: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
Thread-Topic: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
Thread-Index: AQHPMTdfHn6q0sLFtkmQnfSG9aPWEJrFsrSA//+qwwCAABEV4IAAIBBQ
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE54EC4135A5@SC-VEXCH4.marvell.com>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
 <1393228996-14787-3-git-send-email-zhangwm@marvell.com>
 <20140225011839.GD7540@shlinux1.ap.freescale.net>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC413563@SC-VEXCH4.marvell.com>
 <6ad74d797ecc473f922ffdb58c3e9c70@BN1PR03MB235.namprd03.prod.outlook.com>
In-Reply-To: <6ad74d797ecc473f922ffdb58c3e9c70@BN1PR03MB235.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-25_01:2014-02-25,2014-02-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1402240223
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1P7CXrK020394


> -----Original Message-----
> From: Peter Chen [mailto:Peter.Chen@freescale.com]
> Sent: 2014Äê2ÔÂ25ÈÕ 13:15
> To: Neil Zhang
> Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: RE: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
> 
> 
> 
> 
> > > On Mon, Feb 24, 2014 at 04:03:12PM +0800, Neil Zhang wrote:
> > > > Hardware zlt will try to send the zero length packet automatically
> > > > when the data transferd is multiple times of max packet, this will
> > > > cause issues on Windows.
> > > > So let's disable HW zlt by default.
> > >
> > > Would you have description that what kinds of issue on Windows if
> > > zlt is is selected?
> > >
> >
> > Enumeration will fail.
> >
> 
> What causes enumeration fail, why it does not occur before?
> 
A unexpected zero packet cause enumeration fail.
It's not easy that the descriptor is actually 1024 bytes, so not easy to be found.

> Peter

Best Regards,
Neil Zhang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

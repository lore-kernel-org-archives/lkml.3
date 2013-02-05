Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab3BEEbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 23:31:53 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:53327 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab3BEEbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 23:31:51 -0500
From: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        "Huqiao (C)" <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>,
        "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>
Subject: RE: [PATCH 1/2] USB: storage: Define a new macro for USB storage
 match rules
Thread-Topic: [PATCH 1/2] USB: storage: Define a new macro for USB storage
 match rules
Thread-Index: AQHOAwau4UqI5zgLXkiwzjPJTTAg2phqrIoA
Date: Tue, 5 Feb 2013 04:30:33 +0000
Message-ID: <910F9D9E13B84F4C8FA771DC9BDE99F327042DFE@szxeml546-mbx.china.huawei.com>
References: <fe8caaa7d09.d09fe8caaa7@huawei.com>
 <20130204183929.GA5570@kroah.com>
In-Reply-To: <20130204183929.GA5570@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.11.34.182]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r154VsbF012372

Dear  Gregï¼š

	OKï¼Œthank you very much.

Best Regards,
Franko Fang

> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Tuesday, February 05, 2013 2:39 AM
> To: Fangxiaozhi (Franko)
> Cc: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Xueguiying (Zihan);
> Linlei (Lei Lin); Yili (Neil); Wangyuhua (Roger, Credit); Huqiao (C); balbi@ti.com;
> mdharm-usb@one-eyed-alien.net; sebastian@breakpoint.cc
> Subject: Re: [PATCH 1/2] USB: storage: Define a new macro for USB storage
> match rules
> 
> On Mon, Feb 04, 2013 at 03:14:46PM +0800, fangxiaozhi 00110321 wrote:
> > +/* Define the device is matched with Vendor ID and interface
> > +descriptors */ #define UNUSUAL_VENDOR_INTF(id_vendor, cl, sc, pr, \
> > +			vendorName, productName, useProtocol, useTransport, \
> > +			initFunction, flags) \
> > +{ \
> > +	.match_flags = USB_DEVICE_ID_MATCH_INT_INFO \
> > +				| USB_DEVICE_ID_MATCH_VENDOR, \
> > +	.idVendor    = (id_vendor), \
> > +	.bInterfaceClass = (cl), \
> > +	.bInterfaceSubClass = (sc), \
> > +	.bInterfaceProtocol = (pr), \
> > +	.driver_info = (flags) \
> > +}
> 
> I'm not going to reject this given the number of times it has been submitted,
> but can't you use the USB_VENDOR_AND_INTERFACE_INFO() macro here in
> this definition?
> 
> If so, can you send me an add-on patch that makes that change?
> 
> thanks,
> 
> greg k-h
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

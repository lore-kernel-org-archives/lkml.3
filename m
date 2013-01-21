Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3AUDjL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 22:39:11 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:44662 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab3AUDjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 22:39:10 -0500
From: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
To: Greg KH <greg@kroah.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        "Huqiao (C)" <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>,
        "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>
Subject: RE: USB: storage: optimize the matching rules and support new
 switch command for Huawei USB storage devices
Thread-Topic: USB: storage: optimize the matching rules and support new
 switch command for Huawei USB storage devices
Thread-Index: AQHN9dWvRQ2hZuXEpkGIic+AV6y7wZhTJJRQ
Date: Mon, 21 Jan 2013 03:37:15 +0000
Message-ID: <910F9D9E13B84F4C8FA771DC9BDE99F327016D33@szxeml546-mbx.china.huawei.com>
References: <fe8c85797e7f.7e7ffe8c8579@huawei.com>
 <20130118234359.GA2160@kroah.com>
In-Reply-To: <20130118234359.GA2160@kroah.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0L3dRdV017572

Dear Greg:
	

> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Saturday, January 19, 2013 7:44 AM
> To: Fangxiaozhi (Franko)
> Cc: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Xueguiying (Zihan);
> Linlei (Lei Lin); Yili (Neil); Wangyuhua (Roger, Credit); Huqiao (C); balbi@ti.com;
> mdharm-usb@one-eyed-alien.net; sebastian@breakpoint.cc
> Subject: Re: USB: storage: optimize the matching rules and support new switch
> command for Huawei USB storage devices
> 
> On Mon, Jan 14, 2013 at 10:55:48AM +0800, fangxiaozhi 00110321 wrote:
> >
> > From: fangxiaozhi <huananhu@huawei.com>
> >
> > 1. Optimize the matching rules with new macro for Huawei USB storage
> >    devices, to avoid to load USB storage driver for the modem interface
> >    with Huawei devices.
> > 2. Add to support new switch command for new Huawei USB dongles.
> >
> > Signed-off-by: fangxiaozhi <huananhu@huawei.com>
> 
> This patch breaks the build, did you test it out?
> 
> I get the following errors:
> 
> drivers/usb/storage/unusual_devs.h:1530:1: error: implicit declaration of
> function â€˜UNUSUAL_VENDOR_INTFâ€™ [-Werror=implicit-function-declaration]
> drivers/usb/storage/unusual_devs.h:1534:3: warning: missing braces around
> initializer [-Wmissing-braces]
> drivers/usb/storage/unusual_devs.h:1534:3: warning: (near initialization for
> â€˜us_unusual_dev_list[186]â€™) [-Wmissing-braces]
> drivers/usb/storage/unusual_devs.h:1534:3: error: initializer element is not
> constant
> drivers/usb/storage/unusual_devs.h:1534:3: error: (near initialization for
> â€˜us_unusual_dev_list[186].vendorNameâ€™)
> drivers/usb/storage/unusual_devs.h:1537:1: warning: braces around scalar
> initializer [enabled by default]
> 
> And it goes on and on...
----------The macro define, please see another patch: 
	[PATCH 1/1]linux-usb:Define a new macro for USB storage match rules
	http://www.spinics.net/lists/linux-usb/msg76629.html
> Care to fix this up and resend it?
> 
> thanks,
> 
> greg k-h

Best Regards,
Franko Fang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

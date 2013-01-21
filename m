Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3AUDmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 22:42:19 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:46203 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab3AUDmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 22:42:18 -0500
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
Subject: RE: USB: storage: optimize the matching rules and support new
 switch command for Huawei USB storage devices
Thread-Topic: USB: storage: optimize the matching rules and support new
 switch command for Huawei USB storage devices
Thread-Index: AQHN9dV9RQ2hZuXEpkGIic+AV6y7wZhTJZOA
Date: Mon, 21 Jan 2013 03:41:20 +0000
Message-ID: <910F9D9E13B84F4C8FA771DC9BDE99F327016D43@szxeml546-mbx.china.huawei.com>
References: <fe8c85797e7f.7e7ffe8c8579@huawei.com>
 <20130118234226.GA30704@kroah.com>
In-Reply-To: <20130118234226.GA30704@kroah.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0L3gLfo017757

Dear Greg:

> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Saturday, January 19, 2013 7:42 AM
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
> Next time, please always use the scripts/checkpatch.pl tool to find any
> problems you might have made in your patch (you had trailing whitespace in
> this one, which I have fixed.)
> 
-----Yes, I have checked my patch with scripts/checkpatch.pl tool before submitting.
-----For this trailing whitespace error, I think that it is better readable to leave whitespace in our patch code. Isn't it?

> Also, you might want to use git, it makes creating the patches easier, that way
> you don't end up with lines in the patch like this one:
> 
> > Binary files linux-3.8-rc3_orig/drivers/usb/storage/initializers.o and
> > linux-3.8-rc3/drivers/usb/storage/initializers.o differ
> 
> thanks,
> 
> greg k-h

Best Regards,
Franko Fang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

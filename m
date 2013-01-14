Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab3ANCa7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 21:30:59 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:47445 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3ANCa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 21:30:57 -0500
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
Subject: RE: [PATCH 2/2]linux-usb:optimize to match the Huawei USB storage
 devices and support new switch command
Thread-Topic: [PATCH 2/2]linux-usb:optimize to match the Huawei USB storage
 devices and support new switch command
Thread-Index: AQHN8FroNFicYrhkB0afGU4tPzJlqZhIG3lQ
Date: Mon, 14 Jan 2013 02:29:54 +0000
Message-ID: <910F9D9E13B84F4C8FA771DC9BDE99F327006828@szxeml546-mbx.china.huawei.com>
References: <fe8cd5406b9b.6b9bfe8cd540@huawei.com>
 <20130112002217.GA26346@kroah.com>
In-Reply-To: <20130112002217.GA26346@kroah.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0E2VCl2030182

Dear Greg:

> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Saturday, January 12, 2013 8:22 AM
> To: Fangxiaozhi (Franko)
> Cc: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Xueguiying (Zihan);
> Linlei (Lei Lin); Yili (Neil); Wangyuhua (Roger, Credit); Huqiao (C); balbi@ti.com;
> mdharm-usb@one-eyed-alien.net; sebastian@breakpoint.cc
> Subject: Re: [PATCH 2/2]linux-usb:optimize to match the Huawei USB storage
> devices and support new switch command
> 
> On Fri, Jan 11, 2013 at 05:57:44PM +0800, fangxiaozhi 00110321 wrote:
> > From: fangxiaozhi <huananhu@huawei.com>
> >
> > 1. Optimize the match rules with new macro for Huawei USB storage devices,
> >    to avoid to load USB storage driver for the modem interface
> >    with Huawei devices.
> > 2. Add to support new switch command for new Huawei USB dongles.
> 
> I don't see a 1/2 patch in this series, yet I see two different 1/1 patches.
--Yes, this email includes the entire patch. 
--I mask the "2/2" to distinguish it from the previous email, which mask 1/1.

> 
> Can you resend all of your outstanding patchs, in the correct order, with the
> correct numbering, so I know what order to apply them in?
> 
-----This email is the whole patch, so can I resend it again?

> thanks,
> 
> greg k-h

Best Regards,
Franko Fang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

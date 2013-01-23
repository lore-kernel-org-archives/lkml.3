Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab3AWDZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 22:25:28 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:36792 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab3AWDZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 22:25:24 -0500
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
Thread-Index: AQHN9dWvRQ2hZuXEpkGIic+AV6y7wZhTJJRQgABelICAAZJQ0P//3BMAgAFUEDA=
Date: Wed, 23 Jan 2013 03:24:22 +0000
Message-ID: <910F9D9E13B84F4C8FA771DC9BDE99F32701F91A@szxeml546-mbx.china.huawei.com>
References: <fe8c85797e7f.7e7ffe8c8579@huawei.com>
 <20130118234359.GA2160@kroah.com>
 <910F9D9E13B84F4C8FA771DC9BDE99F327016D33@szxeml546-mbx.china.huawei.com>
 <20130121171219.GB4997@kroah.com>
 <910F9D9E13B84F4C8FA771DC9BDE99F32701CC26@szxeml546-mbx.china.huawei.com>
 <20130122150340.GA10105@kroah.com>
In-Reply-To: <20130122150340.GA10105@kroah.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0N3Pdtt000759

Dear Greg:

> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, January 22, 2013 11:04 PM
> To: Fangxiaozhi (Franko)
> Cc: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Xueguiying (Zihan);
> Linlei (Lei Lin); Yili (Neil); Wangyuhua (Roger, Credit); Huqiao (C); balbi@ti.com;
> mdharm-usb@one-eyed-alien.net; sebastian@breakpoint.cc
> Subject: Re: USB: storage: optimize the matching rules and support new switch
> command for Huawei USB storage devices
> 
> On Tue, Jan 22, 2013 at 09:16:08AM +0000, Fangxiaozhi (Franko) wrote:
> > Dear Greg:
> >
> > 	OK, I have fixed up and resend the patches based on linux-3.8-rc4 today.
> >
> > 	Email subjects:
> > 		1. [PATCH 1/2]linux-usb:define new macro and add new match rules
> for Huawei USB storage devices
> > 		2. [PATCH 2/2]linux-usb:define new macro and add new match rules
> for
> > Huawei USB storage devices
> 
> You sent me two patches, both with the same exact Subject: line.  That's not
> ok, please be descriptive in the subject lines as to what each individual patch
> does, as obviously they both don't do the same thing, right?

----No, they do the same thing, so can I submit them in only one patch?
----(Last time, Sebastian thought that the one patch is too long, so he advised me to separate it into two patches).
> 
> Please fix that up and resend the two patches.
> 
> thanks,
> 
> greg k-h

Best Regards,
Franko Fang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

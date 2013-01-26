Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab3AZBk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:40:59 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:39068 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3AZBk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:40:56 -0500
From: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
To: Greg KH <greg@kroah.com>
CC: Sergei Shtylyov <sshtylyov@mvista.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        "Huqiao (C)" <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>,
        "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>
Subject: RE: [PATCH 1/2]linux-usb:Define a new macro for USB storage match
 rules
Thread-Topic: [PATCH 1/2]linux-usb:Define a new macro for USB storage match
 rules
Thread-Index: AQHN+vYlY1KmrgKSx0eF9004qUfo5phZy0YAgAEKE+A=
Date: Sat, 26 Jan 2013 01:39:50 +0000
Message-ID: <910F9D9E13B84F4C8FA771DC9BDE99F32702A880@szxeml546-mbx.china.huawei.com>
References: <fe6cef496609.6609fe6cef49@huawei.com>
 <5102781A.8070502@mvista.com> <20130125174442.GA32333@kroah.com>
In-Reply-To: <20130125174442.GA32333@kroah.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0Q1fD2M024218



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Saturday, January 26, 2013 1:45 AM
> To: Fangxiaozhi (Franko)
> Cc: Sergei Shtylyov; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org;
> Xueguiying (Zihan); Linlei (Lei Lin); Yili (Neil); Wangyuhua (Roger, Credit);
> Huqiao (C); balbi@ti.com; mdharm-usb@one-eyed-alien.net;
> sebastian@breakpoint.cc
> Subject: Re: [PATCH 1/2]linux-usb:Define a new macro for USB storage match
> rules
> 
> On Fri, Jan 25, 2013 at 04:18:34PM +0400, Sergei Shtylyov wrote:
> > Hello.
> >
> > On 25-01-2013 6:44, fangxiaozhi 00110321 wrote:
> >
> > >From: fangxiaozhi <huananhu@huawei.com>
> >
> > >1. Define a new macro for USB storage match rules:
> > >     matching with Vendor ID and interface descriptors.
> >
> > >Signed-off-by: fangxiaozhi <huananhu@huawei.com>
> > >--------------------------------------------------------------------
> > >
> > >  diff -uprN linux-3.8-rc4_orig/drivers/usb/storage/usb.c
> > >linux-3.8-rc4/drivers/usb/storage/usb.c
> > >--- linux-3.8-rc4_orig/drivers/usb/storage/usb.c 2013-01-22
> > >14:12:42.595238727 +0800
> > >+++ linux-3.8-rc4/drivers/usb/storage/usb.c 2013-01-22
> > >+++ 14:16:01.398250305 +0800
> > >@@ -120,6 +120,17 @@ MODULE_PARM_DESC(quirks, "supplemental l
> > >   .useTransport = use_transport, \
> > >  }
> > >
> > >+#define UNUSUAL_VENDOR_INTF(idVendor, cl, sc, pr, \
> > >+         vendor_name, product_name, use_protocol, use_transport, \
> > >+         init_function, Flags) \
> > >+{ \
> > >+ .vendorName = vendor_name, \
> > >+ .productName = product_name, \
> > >+ .useProtocol = use_protocol, \
> > >+ .useTransport = use_transport, \
> > >+ .initFunction = init_function, \
> > >+}
> >
> >   Shouldn't the field initilaizers be indented with tab, not space?
> 
> Yes it must.  fangxiaozhi, please always run your patches through the
> scripts/checkpatch.pl tool before sending them out (note, you will have to
> ignore the CamelCase warnings your patch produces, but not the other
> ones.)
> 
-----What's wrong with it?
-----I have checked the patches with scripts/checkpatch.pl before sending.
-----There is no other warning or error in my patches except CamelCase warnings.
-----So what's wrong now?

> Please do that on both of these patches and resend them.
> 
> thanks,
> 
> greg k-h
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

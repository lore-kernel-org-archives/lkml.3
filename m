Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751096Ab3JLEOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 00:14:10 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:11566 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3JLEOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 00:14:08 -0400
From: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Heyongquan <heyongquan@huawei.com>, Wangyuhua <yuhua.wang@huawei.com>,
        "Yili (Neil)" <neil.yi@huawei.com>
Subject: RE: [PATCH 1/1] support new huawei devices in option.c
Thread-Topic: [PATCH 1/1] support new huawei devices in option.c
Thread-Index: Ac7GMmWW1ERhmJCBQDySorFikvBIlQATxuMAAB/VxgA=
Date: Sat, 12 Oct 2013 04:13:39 +0000
Message-ID: <910F9D9E13B84F4C8FA771DC9BDE99F35E24FE66@szxema506-mbs.china.huawei.com>
References: <910F9D9E13B84F4C8FA771DC9BDE99F35E24BA90@szxema506-mbs.china.huawei.com>
 <20131011205756.GA8181@kroah.com>
In-Reply-To: <20131011205756.GA8181@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.11.34.192]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg:

>-----Original Message-----
>From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
>Sent: Saturday, October 12, 2013 4:58 AM
>To: Fangxiaozhi (Franko)
>Cc: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Heyongquan;
>Wangyuhua; Yili (Neil)
>Subject: Re: [PATCH 1/1] support new huawei devices in option.c
>
>On Fri, Oct 11, 2013 at 03:48:21AM +0000, Fangxiaozhi (Franko) wrote:
>> 1. Add new supporting declarations to option.c, to support Huawei new
>devices with new bInterfaceSubClass value.
>> Signed-off-by: fangxiaozhi <huananhu@huawei.com>
>
>In the future, can you use an email client that doesn't turn tabs into spaces, so I
>don't have to edit the patch by hand?
>
>Also:
>
>> + { USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03,
>0x01)
>> + }, { USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03,
>> + 0x02) },
>
><snip>
>
>That's a huge list of ids, is there any way we can just mark all of these as used by
>the device in an easier manner?
-----OK, I will. Thank you very much.
>
>I'll take this for now, but I have a feeling that this list is just going to get worse
>over time, right?
-----Yes, I think so. So we are discussing about this internally, and maybe try to optimize it later.
>
>thanks,
>
>greg k-h

Best Regards,
Franko Fang

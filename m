Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab3JKU6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:58:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3JKU55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 16:57:57 -0400
Date: Fri, 11 Oct 2013 13:57:56 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Heyongquan <heyongquan@huawei.com>, Wangyuhua <yuhua.wang@huawei.com>,
        "Yili (Neil)" <neil.yi@huawei.com>
Subject: Re: [PATCH 1/1] support new huawei devices in option.c
Message-ID: <20131011205756.GA8181@kroah.com>
References: <910F9D9E13B84F4C8FA771DC9BDE99F35E24BA90@szxema506-mbs.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <910F9D9E13B84F4C8FA771DC9BDE99F35E24BA90@szxema506-mbs.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 03:48:21AM +0000, Fangxiaozhi (Franko) wrote:
> 1. Add new supporting declarations to option.c, to support Huawei new devices with new bInterfaceSubClass value.
> Signed-off-by: fangxiaozhi <huananhu@huawei.com>

In the future, can you use an email client that doesn't turn tabs into
spaces, so I don't have to edit the patch by hand?

Also:

> + { USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x01) },
> + { USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x02) },

<snip>

That's a huge list of ids, is there any way we can just mark all of
these as used by the device in an easier manner?

I'll take this for now, but I have a feeling that this list is just
going to get worse over time, right?

thanks,

greg k-h

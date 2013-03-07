Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795Ab3CGDRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 22:17:37 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:38321 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab3CGDRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 22:17:35 -0500
Date: Thu, 7 Mar 2013 11:18:00 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
Cc: Dan Williams <dcbw@redhat.com>, "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Yili (Neil)" <neil.yi@huawei.com>, Wangyuhua <yuhua.wang@huawei.com>,
        "Huqiao (C)" <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>,
        "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>,
        stable <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSN?= =?utf-8?Q?=3A?= [PATCH] USB: storage: fix
 Huawei mode switching regression
Message-ID: <20130307031800.GA4135@kroah.com>
References: <87obezs888.fsf@nemi.mork.no>
 <1362403161-23501-1-git-send-email-bjorn@mork.no>
 <910F9D9E13B84F4C8FA771DC9BDE99F32709833E@szxeml546-mbx.china.huawei.com>
 <8738waqhx2.fsf@nemi.mork.no>
 <43F99538ECE41341993F359D4AA4FB5F4B3783F2@szxeml560-mbs.china.huawei.com>
 <20130306014424.GA8408@kroah.com>
 <1362584750.21968.1.camel@dcbw.foobar.com>
 <910F9D9E13B84F4C8FA771DC9BDE99F32709E060@szxeml546-mbx.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <910F9D9E13B84F4C8FA771DC9BDE99F32709E060@szxeml546-mbx.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 02:54:38AM +0000, Fangxiaozhi (Franko) wrote:
> Dear All：
> As far as I know, except switching in kernel, there isn't any mode switch solution on Android now.
> Do you have any good ideas for the mode switch on Android system?

Please discuss this with the Android developers, there's nothing that us
(the kernel community) can do about the Android userspace code, sorry.

Please work with Google to solve this properly there.

good luck,

greg k-h

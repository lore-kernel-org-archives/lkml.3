Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3AURLC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:11:02 -0500
Received: from mail.kernel.org ([198.145.19.201]:59367 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab3AURLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:11:00 -0500
Date: Mon, 21 Jan 2013 09:12:19 -0800
From: Greg KH <greg@kroah.com>
To: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        "Huqiao (C)" <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>,
        "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>
Subject: Re: USB: storage: optimize the matching rules and support new switch
 command for Huawei USB storage devices
Message-ID: <20130121171219.GB4997@kroah.com>
References: <fe8c85797e7f.7e7ffe8c8579@huawei.com>
 <20130118234359.GA2160@kroah.com>
 <910F9D9E13B84F4C8FA771DC9BDE99F327016D33@szxeml546-mbx.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <910F9D9E13B84F4C8FA771DC9BDE99F327016D33@szxeml546-mbx.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 03:37:15AM +0000, Fangxiaozhi (Franko) wrote:
> Dear Greg:
> 	
> > I get the following errors:
> > 
> > drivers/usb/storage/unusual_devs.h:1530:1: error: implicit declaration of
> > function ‘UNUSUAL_VENDOR_INTF’ [-Werror=implicit-function-declaration]
> > drivers/usb/storage/unusual_devs.h:1534:3: warning: missing braces around
> > initializer [-Wmissing-braces]
> > drivers/usb/storage/unusual_devs.h:1534:3: warning: (near initialization for
> > ‘us_unusual_dev_list[186]’) [-Wmissing-braces]
> > drivers/usb/storage/unusual_devs.h:1534:3: error: initializer element is not
> > constant
> > drivers/usb/storage/unusual_devs.h:1534:3: error: (near initialization for
> > ‘us_unusual_dev_list[186].vendorName’)
> > drivers/usb/storage/unusual_devs.h:1537:1: warning: braces around scalar
> > initializer [enabled by default]
> > 
> > And it goes on and on...
> ----------The macro define, please see another patch: 
> 	[PATCH 1/1]linux-usb:Define a new macro for USB storage match rules
> 	http://www.spinics.net/lists/linux-usb/msg76629.html

Please resend it, I do not have this patch anymore in my queue.
Remember, I asked you to resend everything that was needed, with the
proper ordering.

Please resend all patches, properly fixed up, that you wish to see
applied.

thanks,

greg k-h

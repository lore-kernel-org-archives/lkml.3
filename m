Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab3AVPC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:02:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:37113 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346Ab3AVPCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:02:24 -0500
Date: Tue, 22 Jan 2013 07:03:40 -0800
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
Message-ID: <20130122150340.GA10105@kroah.com>
References: <fe8c85797e7f.7e7ffe8c8579@huawei.com>
 <20130118234359.GA2160@kroah.com>
 <910F9D9E13B84F4C8FA771DC9BDE99F327016D33@szxeml546-mbx.china.huawei.com>
 <20130121171219.GB4997@kroah.com>
 <910F9D9E13B84F4C8FA771DC9BDE99F32701CC26@szxeml546-mbx.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <910F9D9E13B84F4C8FA771DC9BDE99F32701CC26@szxeml546-mbx.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 09:16:08AM +0000, Fangxiaozhi (Franko) wrote:
> Dear Greg:
> 
> 	OK, I have fixed up and resend the patches based on linux-3.8-rc4 today.
> 
> 	Email subjects:
> 		1. [PATCH 1/2]linux-usb:define new macro and add new match rules for Huawei USB storage devices
> 		2. [PATCH 2/2]linux-usb:define new macro and add new match rules for Huawei USB storage devices

You sent me two patches, both with the same exact Subject: line.  That's
not ok, please be descriptive in the subject lines as to what each
individual patch does, as obviously they both don't do the same thing,
right?

Please fix that up and resend the two patches.

thanks,

greg k-h

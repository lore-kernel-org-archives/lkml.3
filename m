Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab3AURLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:11:54 -0500
Received: from mail.kernel.org ([198.145.19.201]:59401 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073Ab3AURLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:11:52 -0500
Date: Mon, 21 Jan 2013 09:13:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
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
Message-ID: <20130121171313.GC4997@kroah.com>
References: <fe8c85797e7f.7e7ffe8c8579@huawei.com>
 <20130118234226.GA30704@kroah.com>
 <910F9D9E13B84F4C8FA771DC9BDE99F327016D43@szxeml546-mbx.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <910F9D9E13B84F4C8FA771DC9BDE99F327016D43@szxeml546-mbx.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 03:41:20AM +0000, Fangxiaozhi (Franko) wrote:
> Dear Greg:
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Saturday, January 19, 2013 7:42 AM
> > To: Fangxiaozhi (Franko)
> > Cc: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Xueguiying (Zihan);
> > Linlei (Lei Lin); Yili (Neil); Wangyuhua (Roger, Credit); Huqiao (C); balbi@ti.com;
> > mdharm-usb@one-eyed-alien.net; sebastian@breakpoint.cc
> > Subject: Re: USB: storage: optimize the matching rules and support new switch
> > command for Huawei USB storage devices
> > 
> > On Mon, Jan 14, 2013 at 10:55:48AM +0800, fangxiaozhi 00110321 wrote:
> > >
> > > From: fangxiaozhi <huananhu@huawei.com>
> > >
> > > 1. Optimize the matching rules with new macro for Huawei USB storage
> > >    devices, to avoid to load USB storage driver for the modem interface
> > >    with Huawei devices.
> > > 2. Add to support new switch command for new Huawei USB dongles.
> > >
> > > Signed-off-by: fangxiaozhi <huananhu@huawei.com>
> > 
> > Next time, please always use the scripts/checkpatch.pl tool to find any
> > problems you might have made in your patch (you had trailing whitespace in
> > this one, which I have fixed.)
> > 
> -----Yes, I have checked my patch with scripts/checkpatch.pl tool before submitting.

Then where did the trailing whitespace come from?

> -----For this trailing whitespace error, I think that it is better
> readable to leave whitespace in our patch code. Isn't it?

Not at the end of lines for no reason, right?

Please fix up and resend.

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab3GZPWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:22:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754Ab3GZPWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:22:11 -0400
Date: Fri, 26 Jul 2013 08:23:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Barry Song <21cnbao@gmail.com>
Cc: balbi@ti.com, Rong Wang <wr011235813@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rong.Wang@csr.com
Subject: Re: [PATCH] usb: udc: add gadget state kobject uevent
Message-ID: <20130726152325.GB27746@kroah.com>
References: <CA+k=oDzZ5sf_wFMUvE_vkkqRQaOV0P3vWP99tDpoZkrwMN7Q+A@mail.gmail.com>
 <20130716063117.GA30320@kroah.com>
 <20130717075706.GC5291@arwen.pp.htv.fi>
 <CA+k=oDza-oN++KCYtVMD0V62xgkJ3ctUOmzNkaYYYhXuKtaWKQ@mail.gmail.com>
 <20130717132736.GA7614@arwen.pp.htv.fi>
 <CA+k=oDy=_CWMCfcGfy=wbhn0BDm45Y8wS=wpe6SviPcnetntTw@mail.gmail.com>
 <20130718084041.GE11251@arwen.pp.htv.fi>
 <CA+k=oDxbu09FoQdOVUQhK-Q4hKuPYyiYDS1akoE2kggN7echgA@mail.gmail.com>
 <20130718101058.GG11251@arwen.pp.htv.fi>
 <CAGsJ_4w_AU81tiOsCgegFhR6fmC_iDdTMqQP0shddZe4+o+6xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4w_AU81tiOsCgegFhR6fmC_iDdTMqQP0shddZe4+o+6xw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 01:56:19PM +0800, Barry Song wrote:
> 2013/7/18 Felipe Balbi <balbi@ti.com>:
> > On Thu, Jul 18, 2013 at 05:28:19PM +0800, Rong Wang wrote:
> >> Hi Felipe,
> >>
> >> Thanks, I'll test the patch.
> >>
> >> But sysfs_notify(&gadget->dev.kobj, NULL, "status"), status or state ?
> >> I notice that DEVICE_ATTR(state, S_IRUGO, usb_gadget_state_show, NULL)
> >
> > good eyes, please send a patch which I'll queue on this -rc and Cc:
> > <stable@vger.kernel.org>.
> 
> ok. i will handle that for rong. and pls consider to merge rong's
> patch about sending uevent.

It needs to be fixed based on the comments I had for it, before _anyone_
can merge it.

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3AZDhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 22:37:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:59838 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740Ab3AZDhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 22:37:18 -0500
Date: Fri, 25 Jan 2013 19:38:54 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        "Huqiao (C)" <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>
Subject: Re: [PATCH 1/2]linux-usb:Define a new macro for USB storage match
 rules
Message-ID: <20130126033854.GA5066@kroah.com>
References: <fe6cef496609.6609fe6cef49@huawei.com>
 <5102781A.8070502@mvista.com>
 <20130125174442.GA32333@kroah.com>
 <910F9D9E13B84F4C8FA771DC9BDE99F32702A880@szxeml546-mbx.china.huawei.com>
 <20130126020535.GA4652@kroah.com>
 <CAA6KcBAuHHiGq05ahjF1TDvs0CaqeruBDhff4r8L=AfsKiCB4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA6KcBAuHHiGq05ahjF1TDvs0CaqeruBDhff4r8L=AfsKiCB4w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 07:10:29PM -0800, Matthew Dharm wrote:
> I suggest one of two options:
> 
> 1) Setup an alternative mail client.  There are many to choose from
> which will not damage your patches.  I personally like 'mutt' (which
> you should be able to install on your linux machine).   Others may be
> able to recommend ones that work for them; in general, I think you
> will find that most e-mail clients that run on Linux will be suitable.

The file, Documentation/email_clients.txt will help out here.

> 2) If you plan on contributing to the linux kernel in the future, it
> may be worth your time to setup a repo on github that Greg can then
> directly pull from.  All you would need to do is send Greg a "pull
> request" indicating the URL of the branch in your repo that he should
> pull from.  Greg can then pull directly from your repo, bypassing this
> issue entirely.

No, sorry, I only pull trees from a _very_ few people, patches are what
I prefer for almost all stuff.  Only subsystem maintainers who I have
been working with for many years will I pull trees from.

sorry,

greg k-h

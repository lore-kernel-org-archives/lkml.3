Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab3H3TLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 15:11:53 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52963 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3H3TLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 15:11:51 -0400
Date: Fri, 30 Aug 2013 12:11:46 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        netdev@vger.kernel.org, linux-watchdog@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/7] Drop support for Renesys H8/300 architecture
Message-ID: <20130830191146.GA12090@roeck-us.net>
References: <1377880842-6835-1-git-send-email-linux@roeck-us.net>
 <20130830184611.GA27455@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130830184611.GA27455@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 08:46:11PM +0200, Wim Van Sebroeck wrote:
> Hi Guenter,
> 
> > H8/300 has been dead for several years, the kernel for it has
> > not compiled for ages, and recent versions of gcc for it are broken.
> > It is time to drop support for it.
> > 
> > Yes, I understand it is not that simple to drop an architecture,
> > and it may need some discussion, but someone has to put a stake
> > into the ground. Keeping a virtually dead architecture on life support
> > takes resources which are better spent elsewhere.
> 
> Agree. You may add my Acked-by.
> How do you plan to get this upstream? Do I need to take the watchdog in my tree or do you plan to keep the set of patches together in one tree?
> 
My plan is create a branch on my repository on kernel.org, ask Stephen
to add it to linux-next, and then ask Linus to pull it after one
release cycle (ie for 3.13). This should give people enough time
to find out about it and complain, and give everyone else enough time
to find any missing pieces.

I would not mind if Linus would agree to pull it right away for 3.12,
but that seems to be a bit on the fast side.

Thanks,
Guenter

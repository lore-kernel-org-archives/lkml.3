Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab3H3SqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 14:46:15 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:59576 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752855Ab3H3SqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 14:46:14 -0400
Date: Fri, 30 Aug 2013 20:46:11 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Guenter Roeck <linux@roeck-us.net>
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
Message-ID: <20130830184611.GA27455@spo001.leaseweb.com>
References: <1377880842-6835-1-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377880842-6835-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> H8/300 has been dead for several years, the kernel for it has
> not compiled for ages, and recent versions of gcc for it are broken.
> It is time to drop support for it.
> 
> Yes, I understand it is not that simple to drop an architecture,
> and it may need some discussion, but someone has to put a stake
> into the ground. Keeping a virtually dead architecture on life support
> takes resources which are better spent elsewhere.

Agree. You may add my Acked-by.
How do you plan to get this upstream? Do I need to take the watchdog in my tree or do you plan to keep the set of patches together in one tree?

Kind regards,
Wim.


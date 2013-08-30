Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab3H3Thr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 15:37:47 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:52551 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab3H3Thn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 15:37:43 -0400
Date: Fri, 30 Aug 2013 12:37:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        IDE-ML <linux-ide@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 0/7] Drop support for Renesys H8/300 architecture
Message-ID: <20130830193740.GA13101@roeck-us.net>
References: <1377880842-6835-1-git-send-email-linux@roeck-us.net>
 <20130830184611.GA27455@spo001.leaseweb.com>
 <20130830191146.GA12090@roeck-us.net>
 <CA+55aFyxHsKhtqqz9jTDYo89bCNqCWhjHGJ4HzFrHnJ0yxLXjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyxHsKhtqqz9jTDYo89bCNqCWhjHGJ4HzFrHnJ0yxLXjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 12:14:20PM -0700, Linus Torvalds wrote:
> On Fri, Aug 30, 2013 at 12:11 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > I would not mind if Linus would agree to pull it right away for 3.12,
> > but that seems to be a bit on the fast side.
> 
> I'm ok with code deletion patches, I don't think that would be a
> problem. I didn't check them, but I assume this is all literally just
> removing code that is conditional on h8/300 config options?
> 
Yes.

I found a couple more since I sent the series, but nothing significant.

What is your preference - keep it until 3.13, or prepare it now and send you
a pull request for 3.12 ?

Thanks,
Guenter

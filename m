Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab3GOSCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:02:09 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51608 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab3GOSCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:02:08 -0400
Date: Mon, 15 Jul 2013 14:02:02 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_* used by user-space to figure out whether a feature is
 on/off
Message-ID: <20130715180202.GB2433@phenom.dumpdata.com>
References: <20130715154050.GA5941@phenom.dumpdata.com>
 <20130715170244.GA29883@kroah.com>
 <20130715172431.GA8034@phenom.dumpdata.com>
 <CA+55aFx0rLqQUig9VHsfckRX650H=kq6hXH35m=yev17zfi0EA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx0rLqQUig9VHsfckRX650H=kq6hXH35m=yev17zfi0EA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 10:46:17AM -0700, Linus Torvalds wrote:
> On Mon, Jul 15, 2013 at 10:24 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> >
> > If life was that simple.. This particular issue was with inhibiting certain
> > config stanzas if certain features were not built in the kernel. Here is the
> > bug that started it:
> >   http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=633127
> 
> Can somebody please open a grub/xen ticket that says all of this is
> just too confusing and broken, and that it should just be removed
> entirely instead of expanded upon?
> 
> This is a grub bug. It really is that simple. Treat it as one.
> 
> I don't want to break user space applications, but this isn't a
> "user-space app". This is "broken kernel support", and when that
> happens, we call them out for being buggy and don't support them
> (example: all the gcc bugs that have caused us problems over the
> years).

How about I make you proud and post a patch. See:

 http://article.gmane.org/gmane.comp.boot-loaders.grub.devel/20332 
> 
>                  Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab3GOTD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:03:27 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48141 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab3GOTDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:03:25 -0400
Date: Mon, 15 Jul 2013 15:03:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: CONFIG_* used by user-space to figure out whether a feature is
 on/off
Message-ID: <20130715190311.GA3385@phenom.dumpdata.com>
References: <20130715154050.GA5941@phenom.dumpdata.com>
 <20130715170244.GA29883@kroah.com>
 <20130715172431.GA8034@phenom.dumpdata.com>
 <CA+55aFx0rLqQUig9VHsfckRX650H=kq6hXH35m=yev17zfi0EA@mail.gmail.com>
 <20130715180202.GB2433@phenom.dumpdata.com>
 <1373912743.2591.34.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373912743.2591.34.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 08:25:43PM +0200, Paul Bolle wrote:
> On Mon, 2013-07-15 at 14:02 -0400, Konrad Rzeszutek Wilk wrote:
> > How about I make you proud and post a patch. See:
> > 
> >  http://article.gmane.org/gmane.comp.boot-loaders.grub.devel/20332 
> 
> And you're now also taking Michael's patch, that triggered this
> discussion, aren't you?

I believe there is a better way of doing this that I had enumerated
in the thread (see "xen: remove unused Kconfig parameter"). That was to
remove the CONFIG_XEN_PRIVILIGED and XEN_CONFIG_DOM0 and instead have an
CONFIG_XEN_HARDWARE_DOMAIN and CONFIG_XEN_CONTROL_DOMAIN which reflect the
reality a lot better.

P.S.
That idea had been percolating a bit - and it started way back with Andrew Jones
proposing an Kconfig patch a year ago - see:
http://lists.xen.org/archives/html/xen-devel/2012-01/msg00500.html for some
backstory.

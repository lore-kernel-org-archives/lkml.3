Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935261Ab3DJUio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:38:44 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:60479 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764955Ab3DJUim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:38:42 -0400
Date: Wed, 10 Apr 2013 13:38:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Gerlando Falauto <gerlando.falauto@keymile.com>,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Simon Guinot <sguinot@lacie.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3b 0/9] refactoring for mask_cache
Message-ID: <20130410203839.GC20356@kroah.com>
References: <1363885931-20571-1-git-send-email-gerlando.falauto@keymile.com>
 <20130321215709.GA27612@kroah.com>
 <alpine.LFD.2.02.1303262136350.22263@ionos>
 <20130326204725.GA4521@kroah.com>
 <alpine.LFD.2.02.1303262153220.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1303262153220.22263@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 09:54:59PM +0100, Thomas Gleixner wrote:
> On Tue, 26 Mar 2013, Greg KH wrote:
> 
> > On Tue, Mar 26, 2013 at 09:37:53PM +0100, Thomas Gleixner wrote:
> > > On Thu, 21 Mar 2013, Greg KH wrote:
> > > 
> > > > On Thu, Mar 21, 2013 at 06:12:02PM +0100, Gerlando Falauto wrote:
> > > > > This patchset addresses a regression found with the Orion GPIO controller
> > > > > when both Edge- and Level- based interrupts are requested within the same
> > > > > GPIO chip. The regression was introduced by e59347a
> > > > > "arm: orion: Use generic irq chip"
> > > > > 
> > > > > thereby affecting all kernel releases since 3.0.x.
> > > > 
> > > > <formletter>
> > > > 
> > > > This is not the correct way to submit patches for inclusion in the
> > > > stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> > > > for how to do this properly.
> > > > 
> > > > </formletter>
> > > 
> > > Aside of that it would be less intrusive for the stable series to
> > > revert the offending commit(s), if that is possible.
> > 
> > If it is reverted in Linus's tree, yes, I can do that.  But if so,
> > please just tag that revert with the Cc: stable marking and then I can
> > pick it up properly.
> > 
> > Otherwise, no, I can't revert something that isn't already fixed in
> > upstream first.
> 
> I know. The proper thing would be:
> 
> patch 1/n   revert (cc'ed to stable)
> patch 2-m/n fix infrastructure
> patch n/n   redo the commit with the proper change
> 
> Though I don't know if it's possible.

Did anything ever come of this?  Do you need me to do anything for
3.8-stable still?

thanks,

greg k-h

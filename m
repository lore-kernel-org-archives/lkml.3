Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbaJ1W2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:28:23 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:27979 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbaJ1W2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:28:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1++NKS4zJqByGl9DnZe2pBY
Date: Tue, 28 Oct 2014 15:26:41 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Felipe Balbi <balbi@ti.com>,
        sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: USB Ethernet gadget on Nokia n900
Message-ID: <20141028222641.GW2542@atomide.com>
References: <20141019090107.GA19132@amd>
 <201410262222.39892@pali>
 <20141026215548.GA9004@amd>
 <201410262323.17891@pali>
 <20141027195209.GP2560@atomide.com>
 <20141027223114.GU2560@atomide.com>
 <20141028220450.GA27667@amd>
 <20141028222123.GA17518@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028222123.GA17518@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [141028 15:22]:
> On Tue 2014-10-28 23:04:50, Pavel Machek wrote:
> > Hi!
> > 
> > > Here's a patch that should fix the issues for built-in USB
> > > gadgets.
> > > 
> > > Pavel, care to see if this gets NFSroot over USB working again
> > > for you?
> > 
> > It seems to have did the trick for me. (Plus I needed to add
> > 
> > +CONFIG_ARM_ATAG_DTB_COMPAT=y
> > +CONFIG_ARM_ATAG_DTB_COMPAT_CMDLINE_FROM_BOOTLOADER=y
> > +# CONFIG_ARM_ATAG_DTB_COMPAT_CMDLINE_EXTEND is not set
> > 
> > to be able to control the command line, that's why testing took me a
> > while.)
> > 
> > Networking now works against 3.17-based kernel. Thanks!
> 
> It works on 3.18-rc1 kernel, too. (I had to hand-modify patch to apply
> to 3.17, no changes needed for 3.18-rc1.)
> 
> Tested-by: Pavel Machek <pavel@ucw.cz>

Whatever we decice to do to fix this regression, it should probably
be backported to at least v3.16 stable for distro use, maybe earlier
too. I'd assume this is broken on multiple platforms currently.

Regards,

Tony

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaJSWbE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:31:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53546 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaJSWbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:31:01 -0400
Date: Mon, 20 Oct 2014 00:30:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: sre@debian.org, sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        balbi@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: USB Ethernet gadget on Nokia n900
Message-ID: <20141019223043.GA12938@amd>
References: <20141019090107.GA19132@amd>
 <201410191658.45851@pali>
 <20141019205033.GA4738@amd>
 <201410192300.20625@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201410192300.20625@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > omap_musb_mailbox: musb core is not yet ready
> > > > 
> > > > message. It looks related...?
> > > 
> > > Can you try tree
> > > https://gitorious.org/linux-n900/linux-n900/ ?
> > > 
> > > I think with rx51_defconfig from above tree it worked fine
> > > for 3.10 - 3.13 versions.
> > 
> > From your tree, I am trying
> > 815039686baffff6432b45028dd405b1981a9112 (3.16 based). I
> > attempted to make gadget drivers build-in and enabled
> > nfsroot. I could not detect nokia on USB after bootup.
> > 
> > Are you sure about defconfig? AFAICT defconfig will always be
> > unsuitable for nfsroot, as it will not contain nfs support
> > built-in...
> > 
> > I am trying c089e5f8ba2d44afd2db2c2042d43ca70205c536 (3.13
> > based). Same result :-(.
> > 
> > Do you have any tree where usb gadget works for you?
> 
> My N900 can boot kernel from v3.12-rc5-n900 branch compiled with 
> arch/arm/configs/rx51_defconfig. Also it can boot full Maemo5 
> system (with CSSU and some minor system changes) and usb network 
> via g_nokia.ko gadget working fine...

Thanks for the info. Network seems to work on this one.

> So if it does not working for you then kernel usb subsystem could 
> have problems with using gadgets directly from zimage.

It seems to work with 3.12, but not with 3.13 (in similar config). If
you could test USB networking in 3.13, that would help...

Thanks,

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

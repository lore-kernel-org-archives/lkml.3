Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbaJ1WV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:21:27 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50707 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbaJ1WVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:21:25 -0400
Date: Tue, 28 Oct 2014 23:21:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tony Lindgren <tony@atomide.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Felipe Balbi <balbi@ti.com>,
        sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: USB Ethernet gadget on Nokia n900
Message-ID: <20141028222123.GA17518@amd>
References: <20141019090107.GA19132@amd>
 <201410262222.39892@pali>
 <20141026215548.GA9004@amd>
 <201410262323.17891@pali>
 <20141027195209.GP2560@atomide.com>
 <20141027223114.GU2560@atomide.com>
 <20141028220450.GA27667@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028220450.GA27667@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-10-28 23:04:50, Pavel Machek wrote:
> Hi!
> 
> > Here's a patch that should fix the issues for built-in USB
> > gadgets.
> > 
> > Pavel, care to see if this gets NFSroot over USB working again
> > for you?
> 
> It seems to have did the trick for me. (Plus I needed to add
> 
> +CONFIG_ARM_ATAG_DTB_COMPAT=y
> +CONFIG_ARM_ATAG_DTB_COMPAT_CMDLINE_FROM_BOOTLOADER=y
> +# CONFIG_ARM_ATAG_DTB_COMPAT_CMDLINE_EXTEND is not set
> 
> to be able to control the command line, that's why testing took me a
> while.)
> 
> Networking now works against 3.17-based kernel. Thanks!

It works on 3.18-rc1 kernel, too. (I had to hand-modify patch to apply
to 3.17, no changes needed for 3.18-rc1.)

Tested-by: Pavel Machek <pavel@ucw.cz>

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

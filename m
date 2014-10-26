Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaJZLI2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 07:08:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43100 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaJZLI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 07:08:27 -0400
Date: Sun, 26 Oct 2014 12:08:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Felipe Balbi <balbi@ti.com>, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: USB Ethernet gadget on Nokia n900
Message-ID: <20141026110825.GA2263@amd>
References: <20141019090107.GA19132@amd>
 <20141019100739.GA2547@amd>
 <20141019152414.GB5189@saruman>
 <20141019191937.GA6438@amd>
 <20141020213518.GB28144@drone.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020213518.GB28144@drone.musicnaut.iki.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On Sun, Oct 19, 2014 at 09:19:37PM +0200, Pavel Machek wrote:
> > I am trying to use nfsroot, so I can't use modules.
> 
> Why not?
> 
> > (I am attaching full config, in case I missed something important).
> 
> I'm using the below config with 3.17 and g_ether works OK.
> 
> (My initramfs modprobes g_ether, runs busybox ifconfig for usb0
> and launches sshd.)

I am trying to get 3.14 kernel to work, first. There, usb gadget works
when compiled into kernel. But with modules, I get

# root@(none):/tmp# insmod libcomposite.ko                                      
# root@(none):/tmp# insmod u_ether.ko                                           
# root@(none):/tmp# insmod usb_f_rndis.ko                                       
# root@(none):/tmp# insmod g_ether.ko                                           

[  169.061218] udc musb-hdrc.0.auto: registering UDC driver [g_ether]
[  169.078918] g_ether musb-hdrc.0.auto: failed to start g_ether: -2

-2 is ENOENT...
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

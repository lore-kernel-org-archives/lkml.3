Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbaJTWmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 18:42:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59577 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbaJTWmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 18:42:14 -0400
Date: Tue, 21 Oct 2014 00:42:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Felipe Balbi <balbi@ti.com>, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: USB Ethernet gadget on Nokia n900
Message-ID: <20141020224212.GA4418@amd>
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

I'm trying to put root filesystem on nfs, without
initrd/initramfs. Thus no modules for me.

> > (I am attaching full config, in case I missed something important).
> 
> I'm using the below config with 3.17 and g_ether works OK.
> 
> (My initramfs modprobes g_ether, runs busybox ifconfig for usb0
> and launches sshd.)

Ok, I was trying to get away without initramfs ... so that setup is
simpler. And yes, I was using legacy boot method.

I switched to device tree based boot and based my config on yours
(with =m -> =y and NFS enabled), but still do not get USB networking
to work. My PC complains:

[153968.993394] usb 4-1: Product: Nokia N900 (Update mode)
[153968.993397] usb 4-1: Manufacturer: Nokia
[153968.993400] usb 4-1: SerialNumber: 4D554D363434323537
[153969.730564] usb 4-1: USB disconnect, device number 122
[153974.592034] usb 4-1: new high-speed USB device number 123 using
ehci-pci
[153989.704035] usb 4-1: device descriptor read/64, error -110
root@amd:/srv/nfs/n900/tmp# 

(and it worked ok with kernels up-to 3.14).

Could you mail me your initramfs or put it on the web somewhere? That
might be useful test...

Thanks and best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720Ab3K1RL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 12:11:56 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51801 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab3K1RLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 12:11:55 -0500
Date: Thu, 28 Nov 2013 18:11:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        OH@amd.pavel.ucw.cz
Subject: Nemo on emulated Nokia n900 (qemu-arm)
Message-ID: <20131128171153.GA20486@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

For testing, it would be good to have some real
userland... unfortunately I can't figure out how to do it.

Ideally, I'd like to put nemo-armv7hl-n900-mmcblk0p.raw on emulated sd
card, but I get:

[    1.566345] Initializing XFRM netlink socket
[    1.568023] NET: Registered protocol family 17
[    1.570220] NET: Registered protocol family 15
[    1.572601] Key type dns_resolver registered
[    1.581481] omap_vp_forceupdate_scale: vdd_mpu_iva TRANXDONE
timeout exceeded while trying to clear the TRANXDONE status
[    1.586242] omap_vp_forceupdate_scale: vdd_core TRANXDONE timeout
exceeded while trying to clear the TRANXDONE status
[    1.601074] omap_vp_forceupdate_scale: vdd_mpu_iva TRANXDONE
timeout exceeded. Voltage change aborted
[    1.604522] cpu cpu0: omap_target: unable to scale voltage up.
[    1.606933] omap_hsmmc omap_hsmmc.1: no support for card's volts
[    1.609252] mmc1: error -22 whilst initialising SDIO card
SD: ACMD41 in a wrong state
SD: ACMD41 in a wrong state
SD: ACMD41 in a wrong state
SD: ACMD41 in a wrong state
SD: CMD1 in a wrong state
[    1.613830] cpufreq: __cpufreq_driver_target: Failed to change cpu
frequency: -110
[    1.622650] ThumbEE CPU extension supported.

But according to google, old linux kernels were able to work with SD
on qemu-arm...

IIRC there was some discussion that qemu does not properly emulate SD
card, and that internal NAND emulation can be used instead. I tried
using qflasher, but it is not able to use 3.5GB
nemo-armv7hl-n900-mmcblk0p.rawnemo-armv7hl-n900-mmcblk0p.raw -- strace
revealed file too big error.

Any ideas?
									Pavel
PS: And sorry if it is in archives somewhere. I googled quite a bit,
but did not find anything.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

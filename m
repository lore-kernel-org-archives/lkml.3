Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbaLHUrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:47:39 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53367 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbaLHUrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:47:37 -0500
Date: Mon, 8 Dec 2014 21:47:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
Cc: balbi@ti.com, Greg KH <greg@kroah.com>, marcel@holtmann.org
Subject: nokia_h4p on 3.16+
Message-ID: <20141208204735.GA21599@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

It seems commit:

commit bd5dc09f557547399cd44d0a1224df7ff64e4a6b
Author: Felipe Balbi <balbi@ti.com>
Date:   Wed Apr 23 09:58:28 2014 -0500

    serial: fix UART_IIR_ID

    UART IRQ Identification bitfield is 3
        bits long (bits 3:1) but current mask only
	    masks 2 bits. Fix it.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

breaks bluetooth driver on n900. (drivers/staging/nokia_h4p).

Pali, you may want to revert the patch.

That is good news, because reverting it on 3.18-rcX brings h4p back,
too (and as machine boots on nfsroot, debugging should be possible.)

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

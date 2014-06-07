Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaFGWx7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 18:53:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36362 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaFGWx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 18:53:58 -0400
Date: Sun, 8 Jun 2014 00:53:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, chris@printf.net,
        dsd@gentoo.org, dsd@laptop.org
Subject: Kernel for olpc-1.75
Message-ID: <20140607225356.GA5696@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I broke installation on olpc-1.75, and I guess its time for it to
start running self-compiled kernel. (It still boots if I hold right
game key, but I can no longer control backlight. It does not boot at
all by default.)

AFAICT, olpc.fth and zImage in the boot/ directory of USB disk should
do the trick.

Unfortunately, 3.0 based kernels no longer compile with current tools,
so I tried this version (3.6 based).

commit 2a873e0e3681412ccc82a646630ffaf119d36af0
Author: Chris Ball <cjb@laptop.org>
Date:   Wed Aug 22 18:51:58 2012 -0400

    Revert "ARM: mmp: Send decompress and debug output to UART3
    instead of UART2
    
    This reverts commit 8fb8e2ccffd5387c4a5e4e5294270fa61716eb51.

Unfortunately, no output at all with
arch/arm/configs/xo_175_defconfig.

I tried replacing all =m's in .config with =y, but still no output.

Is there more recent kernel to work with? Is 2a87... somehow buggy?
Did I miss some critical step? Will recent mainline run on olpc
unmodified?

Thanks,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

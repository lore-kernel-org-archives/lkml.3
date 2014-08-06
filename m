Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbaHFVdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 17:33:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58350 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbaHFVdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 17:33:51 -0400
Date: Wed, 6 Aug 2014 23:33:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Joni Lapilainen <joni.lapilainen@gmail.com>
Subject: Re: linux-n900: v3.16-rc1-n900
Message-ID: <20140806213349.GA26142@amd.pavel.ucw.cz>
References: <201406161635.15577@pali>
 <201406181831.58629@pali>
 <20140806133808.GA17432@amd.pavel.ucw.cz>
 <201408061626.59695@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201408061626.59695@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> you just need to disable CONFIG_TIDSPBRIDGE because it does not
> compile. Now I pushed commit which disabling it into branch
> v3.16-rc1-n900.
> 
> With that kernel it compiles and works fine in qemu.

Thanks, it now works for me, not sure why it did not work before.

Anyway, this is what I noticed while going through the patches...

Signed-off-by: Pavel Machek <pavel@ucw.cz>
									Pavel

diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index d2574b7..0f082f0 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -1,5 +1,5 @@
 /*
- * drivers/media/video/ad5820.c
+ * drivers/media/i2c/ad5820.c
  *
  * AD5820 DAC driver for camera voice coil focus.
  *

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

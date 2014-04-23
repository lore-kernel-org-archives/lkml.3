Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbaDWUWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 16:22:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49420 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbaDWUWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 16:22:50 -0400
Date: Wed, 23 Apr 2014 22:22:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: daniel.vetter@ffwll.ch, jani.nikula@linux.intel.com,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: 3.15-rc2: i915 regression: only top 20% of screen works in X
Message-ID: <20140423202248.GA3621@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

After update to 3.15-rc2, only top 20% of screen works on X.

00:02.0 VGA compatible controller: Intel Corporation 4 Series Chipset
Integrated Graphics Controller (rev 03)

00:02.1 Display controller: Intel Corporation 4 Series Chipset
Integrated Graphics Controller (rev 03)
	   Subsystem: Intel Corporation Device d614
	   Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
	   ParErr- Stepping- SERR- FastB2B- DisINTx-
	   Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast
	   >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	   Latency: 0
	   Region 0: Memory at d0400000 (64-bit, non-prefetchable)
	   [size=1M]
	   Capabilities: <access denied>

This worked before. I believe it worked in 3.14. It definitely works
in 3.11-rc2.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

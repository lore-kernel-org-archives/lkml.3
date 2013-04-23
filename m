Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab3DWJpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 05:45:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36573 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab3DWJpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 05:45:30 -0400
Date: Tue, 23 Apr 2013 11:45:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, perex@perex.cz,
        trivial@kernel.org
Subject: trivial: sound kconfig typo
Message-ID: <20130423094527.GA6004@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix english in sound/drivers/Kconfig.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/sound/drivers/Kconfig b/sound/drivers/Kconfig
index 7d02c32..8545da9 100644
--- a/sound/drivers/Kconfig
+++ b/sound/drivers/Kconfig
@@ -87,7 +87,7 @@ config SND_ALOOP
 	  configured number of substreams (see the pcm_substreams module
           parameter).
 
-	  The looback device allow time sychronization with an external
+	  The loopback device allows time sychronization with an external
 	  timing source using the time shift universal control (+-20%
 	  of system time).
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

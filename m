Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaLHU4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:56:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54536 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387AbaLHU4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:56:32 -0500
Date: Mon, 8 Dec 2014 21:56:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
Subject: Mainline kernel really hates bateries in N900
Message-ID: <20141208205630.GA28391@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

So... I thought leaving N900 with mainline kernel on USB connection
was bad... (end result was battery at 2.97V). Well... now I left the
machine idle without the charger ... and result was 2.85V on battery.

Li-ion batteries should not be discharged below 3.4V. As may batteries
are already reported as 5mAh total capacity from time to time, I'll
just have to get new ones... but perhaps you should not repeat those
experiments.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbbAFREj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:04:39 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34083 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277AbbAFREi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:04:38 -0500
Date: Tue, 6 Jan 2015 18:04:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com
Subject: 3.19 on Nokia n900: audio quality awful
Message-ID: <20150106170433.GA5408@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

In 3.18, sound is nice and clear.

In 3.19, sound is unusable. It produces nasty tone when it should be
quiet, and there's at least as much noise as is sound.

Unfortunately, list of mixers also changed (and there's cca 120
settings), but a) it does not work with the old list and b) nothing I
could figure out did make the sound usable. Some setting resulted in
even more noise.

Any idea what could have caused it?

Thanks,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

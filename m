Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab3KTTVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 14:21:06 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47565 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab3KTTVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 14:21:03 -0500
Date: Wed, 20 Nov 2013 20:21:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, daniel.lezcano@linaro.org,
        will.deacon@arm.com, catalin.marinas@arm.com, olof@lixom.net,
        sudeep.karkadanagesha@arm.com
Subject: Support for ARM architected timer event stream generation on x86
Message-ID: <20131120192100.GA11723@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On x86, I get asked if I want to support arm architectured
timer. That's not exactly clever question... right?

I'd say it is from this merge... please fix.
								Pavel

commit 191124efb4d6e5e47fe073b4b97350873523e88c
Merge: 68e9074 346e748
Author: Daniel Lezcano <daniel.lezcano@linaro.org>
Date:   Thu Oct 3 16:13:51 2013 +0200

    Merge branch 'timer_evtstrm' of git://linux-arm.org/linux-skn into
    clockevents/3.13
    


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

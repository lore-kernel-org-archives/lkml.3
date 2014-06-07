Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaFGMB5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 08:01:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48975 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbaFGMB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 08:01:56 -0400
Date: Sat, 7 Jun 2014 14:01:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Resume from suspend broken in 3.15. (bisected)
Message-ID: <20140607120153.GA4721@amd.pavel.ucw.cz>
References: <20140528172521.GA9945@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528172521.GA9945@milliways>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>  I've only started full testing of 3.15 on one of my machines now
> that -rc7 has been released (this one had two issues in the radeon
> code, second was fixed in rc7).  Unfortunately, suspend to RAM
> (pm-suspend), or rather the wake-up, is broken on this box [ my
> other two boxes are fine in rc7 ].
> 
> Bisection identified one of your commits -
> 
> commit 25f397a429dfa43f22c278d0119a60a343aa568f

Thanks a lot for your work. It seems this commit breaks i915, too.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab3EOJFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:05:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33280 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab3EOJFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:05:07 -0400
Date: Wed, 15 May 2013 11:05:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.10-rc1 system starts regular boot when waking from s2ram
Message-ID: <20130515090505.GA3995@amd.pavel.ucw.cz>
References: <20130514160108.GA5055@dhcp22.suse.cz>
 <1368567715.t1rym2H3RB@vostro.rjw.lan>
 <20130515080122.GC8625@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515080122.GC8625@dhcp22.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Well, it probably is.  I'll try to reproduce it, but if I can't ...
> 
> OK, I am bisecting now. 6 iterations left...

Good luck. I tried to reproduce it locally on thinkpad x60, but it
suspends/resumes ok.

(There seems to be regression in bluetooth; tray widget now shows
bluetooth is unavailable and it can't be turned on. x60 uses btusb.)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

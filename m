Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaLQJXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:23:00 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53955 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaLQJW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:22:58 -0500
Date: Wed, 17 Dec 2014 10:22:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Brian Norris <computersforpeace@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>,
        Chirantan Ekbote <chirantan@chromium.org>
Subject: Re: [PATCH] PM / sleep: add configurable delay for pm_test
Message-ID: <20141217092255.GA4588@amd>
References: <1409788535-28264-1-git-send-email-computersforpeace@gmail.com>
 <20141213025530.GO21347@ld-irv-0074>
 <20141213083123.GA26129@amd>
 <20141216235813.GI9759@ld-irv-0074>
 <20141217080947.GB2027@amd>
 <20141217091057.GH7112@brian-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141217091057.GH7112@brian-ubuntu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Make it module parameter so that the patch is two lines of code. If
> > that does not work for you, think of something that does.
> 
> OK, so that's actually constructive. If lines of code is really the most
> important factor here, then I suppose I can do that. I'd argue that a
> module parameter is a much less sensible interface here, though, given
> that it is coupled with the existing /sys/power/pm_test interface.

If module parameter works for you, we have a winner, that should be
two lines of code and two lines of documentation.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

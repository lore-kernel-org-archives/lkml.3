Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbaLJNcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:32:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41291 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbaLJNca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:32:30 -0500
Date: Wed, 10 Dec 2014 14:32:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, b.zolnierkie@samsung.com,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC v8 02/14] Documentation: leds: Add description of LED
 Flash class extension
Message-ID: <20141210133228.GB14748@amd>
References: <547C539A.4010500@samsung.com>
 <20141201130437.GB24737@amd>
 <547C7420.4080801@samsung.com>
 <CAK5ve-KMNszyz6br_Q_dOhvk=_8ev6Uz-ZhPnYBn-ZvuohQpVA@mail.gmail.com>
 <20141206124310.GB3411@amd>
 <5485D7F8.10807@samsung.com>
 <20141208201855.GA16648@amd>
 <5486B8AE.5000408@samsung.com>
 <20141209155033.GB21422@amd>
 <548847DB.2090806@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548847DB.2090806@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>both sides: LED Flash class core and a LED Flash class driver.
> >>In the former the sysfs attribute write permissions would have
> >>to be decided in the runtime and in the latter caching mechanism
> >
> >Write attributes at runtime? Why? We can emulate sane and consistent
> >behaviour for all the controllers: read gives you list of faults,
> >write clears it. We can do it for all the controllers.
> 
> I don't like the idea of listing the faults in the form of strings.
> I'd like to see the third opinion :)

Well, I see that you don't like to change existing code. But "I hacked
it this way and I'm going to ask n-th opinion so that I don't have to
touch it" is not a way to design interfaces.

> >Only cost is few lines of code in the drivers where hardware clears
> >faults at read.
> 
> As above - the third opinion would be appreciated.

Just email Greg if he likes /sys files with sideffects on read.

Or just think. You never do grep in /sys?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

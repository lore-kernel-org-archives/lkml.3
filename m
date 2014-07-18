Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729AbaGRHw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 03:52:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35942 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaGRHw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 03:52:56 -0400
Date: Fri, 18 Jul 2014 09:52:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: Sebastian Reichel <sre@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH 2/4] power_supply: Introduce generic psy charging driver
Message-ID: <20140718075254.GA22791@amd.pavel.ucw.cz>
References: <1404799461-26345-1-git-send-email-jenny.tc@intel.com>
 <1404799461-26345-3-git-send-email-jenny.tc@intel.com>
 <20140718021836.GD21934@earth.universe>
 <20ADAB092842284E95860F279283C56422FBE00C@BGSMSX104.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20ADAB092842284E95860F279283C56422FBE00C@BGSMSX104.gar.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I suggest to add features supported by charger-manager to power supply charging
> > driver and convert users of charger-manager to the improved driver.
> > 
> > I CC'd MyungJoo Ham, who wrote the charger-manager, so that he can also give
> > feedback.
> 
> We are back to the initial discussions we had in the list. The initial proposal
> was for the charger manager. The charger manager is more aligned to
> regulator framework, use private notification
> mechanisms(cm_notify_event,fullbatt_vchk etc) and relies more on
> platform data (struct charger_desc). This doesn't seems to be good to support plug in
> charger drivers, charging algorithms, battery identification drivers
> at runtime.

>From what I seen, the new "plug in friendly" approach is unsuitable
for the kernel.

I really tried hard to review it, and it went through how many, 10?,
iterations, and it is not getting better.

So please just extend existing code.

If you insist that is not adequate, please talk to some experienced
hacker at Intel (does Rafael still work there? Ingo?) to design
acceptable solution.

Seeing same patches for 10 iterations with no real improvements is not
fun.

Thanks,
									Pavel 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

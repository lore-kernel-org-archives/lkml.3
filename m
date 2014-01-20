Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbaATUo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 15:44:57 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42274 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaATUoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 15:44:54 -0500
Date: Mon, 20 Jan 2014 21:44:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "markgross@thegnar.org" <markgross@thegnar.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [11/11] system 1: Saving energy using DVFS
Message-ID: <20140120204452.GB26780@amd.pavel.ucw.cz>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
 <1389111587-5923-12-git-send-email-morten.rasmussen@arm.com>
 <20140120164926.GB23051@amd.pavel.ucw.cz>
 <20140120171010.GB29971@arm.com>
 <20140120175431.GB25439@amd.pavel.ucw.cz>
 <20140120181647.GJ29971@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120181647.GJ29971@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Race to idle doesn't mean that the screen goes off as well. Let's say
> > > the screen stays on for 1 min and the CPU needs to be running for 10s
> > > over this minute, in the first case you have:
> > 
> > No, it does not. I just assumed user is continuing to use his
> > machine. Obviously, waiting 60 seconds with screen on will make the
> > difference look smaller. But your solution still means user has to
> > wait longer _and_ you consume more battery doing so.
> > 
> > And this is for any task where user waits for result with screen
> > on. Like rendering a webpage. Like opening settings screen. Like
> > installing application.
> 
> Page rendering should make very little difference to power since the
> reading (screen on) time is much larger than the rendering (CPU)
> time.

For some uses, yes, for some uses (searching for bus time tables,
displaying weather) not neccessarily. And I suspect that the whole CPU
consumption takes a little difference in power, anyways...

> But what I'm pointing at for 10s/60s ratios are thing like games or
> video playing where the CPU is running for 1/6 of the time and idle for
> the other 5/6. We get better energy figures by changing the run time to
> 3/6 and idle at 3/6.

Better energy figures on complete system consumption, on phone-type
device that can be bought in the shop?

> > But hey, maybe you are right and running at lowest possible frequency
> > is right. Please provide concrete numbers like I did.
> 
> They've been anonymised (for many reasons) and you have the right not to
> trust them. But do you really think we are making up the numbers? We

"Here is power consumption of unspecified part of machine in
unspecified units on machine of unspecified type. Trust us our patches
improve it in unspecified workload". Why should I trust you?

> have a great interest in the Linux scheduler working efficiently on the
> ARM platforms rather than optimising it for non-existent scenarios. If
> at some point this argument becomes a blocking factor, I'm sure we can
> share the real numbers with the relevant parties under an NDA.

I'm sure you can just buy Samsung S4 in the nearest shop, and you
probably can find and ampermeter on site... Then perhaps people can
reproduce your results and we can have useful discussion. This is
relevant to production hardware, right?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

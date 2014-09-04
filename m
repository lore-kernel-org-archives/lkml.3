Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbaIDHOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:14:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39225 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaIDHOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:14:16 -0400
Date: Thu, 4 Sep 2014 09:14:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Norris <computersforpeace@gmail.com>
Cc: "Rafael J. Wysocki\"" <rjw@rjwysocki.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] PM / sleep: add configurable delay for pm_test
Message-ID: <20140904071412.GA29832@amd>
References: <1409788535-28264-1-git-send-email-computersforpeace@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409788535-28264-1-git-send-email-computersforpeace@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> When CONFIG_PM_DEBUG=y, we provide a sysfs file (/sys/power/pm_test) for
> selecting one of a few suspend test modes, where rather than entering a
> full suspend state, the kernel will perform some subset of suspend
> steps, wait 5 seconds, and then resume back to normal operation.
> 
> This mode is useful for (among other things) observing the state of the
> system just before entering a sleep mode, for debugging or analysis
> purposes. However, a constant 5 second wait is not sufficient for some
> sorts of analysis; for example, on an SoC, one might want to use
> external tools to probe the power states of various on-chip controllers
> or clocks.

When you are doing this kind of analysis, perhaps directly modifying
kernel source is the way to go ...?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

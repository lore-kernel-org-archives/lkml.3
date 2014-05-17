Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030290AbaEQR3a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:29:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36921 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964856AbaEQR33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:29:29 -0400
Date: Sat, 17 May 2014 19:29:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Inderpal Singh <inderpal.s@samsung.com>, Nishanth Menon <nm@ti.com>,
        "[Chander Kashyap" <chander.kashyap@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>
Subject: Re: [PATCH] PM / OPP: discard duplicate OPP additions
Message-ID: <20140517172927.GA309@amd.pavel.ucw.cz>
References: <1399966890-22926-1-git-send-email-k.chander@samsung.com>
 <20140514150255.GA8330@amd.pavel.ucw.cz>
 <CAKohpo=MFxUHL22TxXPk4B=JX9AD3RGdgXPPGK9sD3GD6AEV+g@mail.gmail.com>
 <CAOqmu80j2q6hQLThVt60QkjqcZTXwJ6ddwDLvqBEW1ejrVh_hw@mail.gmail.com>
 <CAKohponWM+RxgK-50BXH-gk3-bX2no7NojT5-6ZRWJAtSizO7A@mail.gmail.com>
 <CAOqmu81C7A-bMQY3p5fsvk-4Y=S1yGZHw_Q=RbxCKxwR9fFz-w@mail.gmail.com>
 <CAKohpon+YbHx_P0oxkT5vSKVn30aZBddykgLLfyg5N3gPEXe6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpon+YbHx_P0oxkT5vSKVn30aZBddykgLLfyg5N3gPEXe6w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> And both these doesn't happen in this case. OPP tables can be used
> by any other framework and is more or less a core thing..
> 
> Now, with this discussion I have another idea here..
> 
> Why don't we build these tables automatically on boot from some core
> code, rather than asking drivers to do it ? That will get rid of duplication
> from all drivers and would also reduce confusion

Yes please.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

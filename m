Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaE2A5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 20:57:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:4324 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbaE2A5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 20:57:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,931,1392192000"; 
   d="scan'208";a="548099421"
Date: Thu, 29 May 2014 00:53:38 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Doug Smythies <dsmythies@telus.net>
Cc: "'Johan Hovold'" <jhovold@gmail.com>,
        "'Dirk Brandewie'" <dirk.brandewie@gmail.com>,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>, dirk.j.brandewie@intel.com,
        "'Rafael J. Wysocki'" <rafael.j.wysocki@intel.com>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Stratos Karafotis'" <stratosk@semaphore.gr>
Subject: Re: Performance regression in v3.14
Message-ID: <20140528165337.GB2296@intel.com>
References: <20140506163559.GA5308@localhost>
 <CAKohpokYEvazxm0-JJXPzq-4OgLXmROfaCMcgHDZwugChOxtsQ@mail.gmail.com>
 <536A3EE9.5050409@intel.com>
 <20140521090051.GO21412@localhost>
 <20140528075945.GA21705@localhost>
 <20140528003540.GA2296@intel.com>
 <002401cf7a8d$fc6d9090$f548b1b0$@net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002401cf7a8d$fc6d9090$f548b1b0$@net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That is not true. Yes, and due to the setpoint being less than
> 100, which is needed or the driver won't work at all, there is
> a tendency to drive the target pstate upwards.
> However that is tempered by both the PID proportional gain,
> and ultimately integer math. More importantly, the CPU
> itself tells the driver when it is operating below the target
> pstate and driver responds.
> 
> Additionally, the tendency to drive up the target pstate
> too much is exasperated by some extra rounding up at a
> couple of spots. Dirk has a pending fix.
> 
> > And a few iterations
> > later, we will reach max (possible) frequency,
> > then we are effectively performance governor
> > (highest frequency all the time).
> 
> Please do not confuse highest target pstate with
> highest frequency. They are not the same. The processor
> itself can back off.
> 
Hi Doug,

All you said is about the hardware will not give whatever software wants
(e.g., requested freq too high). Agreed.

But does it matter to this discussion?

Yuyang 

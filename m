Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab3EGGxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 02:53:54 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:37584 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab3EGGxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 02:53:52 -0400
Date: Tue, 7 May 2013 08:53:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, John Stultz <john.stultz@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Fwd: [GIT PULL] timer changes for v3.10
Message-ID: <20130507065348.GF17705@gmail.com>
References: <20130430074322.GA20110@gmail.com>
 <20130506230137.GA16801@amd.pavel.ucw.cz>
 <CA++bM2scosWgBpC3_LzcKYOjG4EQQzN5Vf4rZFds-5qRVRwvDQ@mail.gmail.com>
 <20130507023853.GA2945@feng-snb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130507023853.GA2945@feng-snb>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Feng Tang <feng.tang@intel.com> wrote:

> > is even worse than that. Machine can stay is s2ram for weeks (for a 
> > lot more if it is desktop and you do s2ram for powersaving). Also 
> > temperature of CPU varies a lot between active and s2ram states. Is 
> > TSC good enough?
> 
> Yes, I think it is relatively precise. Per our test, system time backed 
> by the S3 non stop TSC only has 1 second drift after 4 days running 
> (with mixed running and S3 states). And before using this feature, we've 
> seen many time drift problems due to the RTC HW or system FW with our 
> platforms.

Nice result ...

Is that with NTP running?

Without NTP, the TSC fast-calibration on bootup is not (expected to be) 
nearly as precise as the 1:345600 precision you've measured.

Thanks,

	Ingo

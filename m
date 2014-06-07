Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaFGWLt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 18:11:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35655 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbaFGWLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 18:11:48 -0400
Date: Sun, 8 Jun 2014 00:11:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        viresh.kumar@linaro.org, svaidy@linux.vnet.ibm.com,
        ego@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] cpufreq: governor: Be friendly towards
 latency-sensitive bursty workloads
Message-ID: <20140607221146.GA28741@amd.pavel.ucw.cz>
References: <20140607204114.25673.87194.stgit@srivatsabhat.in.ibm.com>
 <2855981.L5ysAMpFml@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2855981.L5ysAMpFml@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > the idle time or idle residency; and the high frequency of the CPU when it goes
> > to cpu-idle does not affect/hurt the power-savings of deep idle states).
> > 
> > Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> > Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
> > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Pavel Machek <pavel@ucw.cz>
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

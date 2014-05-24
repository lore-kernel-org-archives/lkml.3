Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaEXM74 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 08:59:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38390 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaEXM7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 08:59:54 -0400
Date: Sat, 24 May 2014 14:59:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Eduardo Valentin <edubezval@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Ips Gandhi <inderpal.s@samsung.com>, Nishanth Menon <nm@ti.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "Brown, Len" <len.brown@intel.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH V3 1/8] cpufreq: cpufreq-cpu0: remove dependency on
 thermal
Message-ID: <20140524125946.GA31533@Nokia-N900>
References: <cover.1400736536.git.viresh.kumar@linaro.org>
 <c73c825beda0207867bd29e40fece217cbf15925.1400736536.git.viresh.kumar@linaro.org>
 <20140522145209.GA5246@developer>
 <CAKohpo=e62HPRF0N7kDvZEBAVPMFUeXVoL4jU--i7bZhn6Kjgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=e62HPRF0N7kDvZEBAVPMFUeXVoL4jU--i7bZhn6Kjgw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-05-23 10:03:27, Viresh Kumar wrote:
> On 22 May 2014 20:22, Eduardo Valentin <edubezval@gmail.com> wrote:
> > However, on CPUs that needs thermal managment, it makes sense to have
> > such dependency, from functional perspective. Mainly because scaling
> > frequency and voltage up would be allowed only when thermal management
> > is enabled.
> 
> AFAIK, dependencies in KCONFIG are only for fixing compilation time issues.

I do not think that's correct.

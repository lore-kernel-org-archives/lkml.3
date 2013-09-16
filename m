Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab3IPOGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 10:06:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41169 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab3IPOGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 10:06:08 -0400
Date: Mon, 16 Sep 2013 16:06:07 +0200
From: Michal Hocko <mhocko@suse.cz>
To: azurIt <azurit@pobox.sk>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] improve memcg oom killer robustness v2
Message-ID: <20130916140607.GC3674@dhcp22.suse.cz>
References: <20130910220329.GK856@cmpxchg.org>
 <20130911143305.FFEAD399@pobox.sk>
 <20130911180327.GL856@cmpxchg.org>
 <20130911205448.656D9D7C@pobox.sk>
 <20130911191150.GN856@cmpxchg.org>
 <20130911214118.7CDF2E71@pobox.sk>
 <20130911200426.GO856@cmpxchg.org>
 <20130914124831.4DD20346@pobox.sk>
 <20130916134014.GA3674@dhcp22.suse.cz>
 <20130916160119.2E76C2A1@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916160119.2E76C2A1@pobox.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 16-09-13 16:01:19, azurIt wrote:
> > CC: "Johannes Weiner" <hannes@cmpxchg.org>, "Andrew Morton" <akpm@linux-foundation.org>, "David Rientjes" <rientjes@google.com>, "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>, "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
> >On Sat 14-09-13 12:48:31, azurIt wrote:
> >[...]
> >> Here is the first occurence, this night between 5:15 and 5:25:
> >>  - this time i kept opened terminal from other server to this problematic one with htop running
> >>  - when server went down i opened it and saw one process of one user running at the top and taking 97% of CPU (cgroup 1304)
> >
> >I guess you do not have a stack trace(s) for that process? That would be
> >extremely helpful.
> 
> I'm afraid it won't be possible as server is completely not responding
> when it happens. Anyway, i don't think it was a fault of one process
> or one user.

You can use sysrq+l via serial console to see tasks hogging the CPU or
sysrq+t to see all the existing tasks.
 
[...]
-- 
Michal Hocko
SUSE Labs

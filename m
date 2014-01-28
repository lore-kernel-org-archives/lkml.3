Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbaA1XEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:04:30 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:42678 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaA1XE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:04:28 -0500
Message-ID: <52E83777.2060909@wwwdotorg.org>
Date: Tue, 28 Jan 2014 16:04:23 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Thierry Reding <thierry.reding@gmail.com>,
        linux-tegra@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-pm@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm, pm, vmpressure: add missing slab.h includes
References: <20140128221922.GC16060@mtj.dyndns.org>
In-Reply-To: <20140128221922.GC16060@mtj.dyndns.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 03:19 PM, Tejun Heo wrote:
> arch/arm/mach-tegra/pm.c, kernel/power/console.c and mm/vmpressure.c
> were somehow getting slab.h indirectly through cgroup.h which in turn
> was getting it indirectly through xattr.h.  A scheduled cgroup change
> drops xattr.h inclusion from cgroup.h and breaks compilation of these
> three files.  Add explicit slab.h includes to the three files.
> 
> A pending cgroup patch depends on this change and it'd be great if
> this can be routed through cgroup/for-3.14-fixes branch.

Acked-by: Stephen Warren <swarren@nvidia.com>

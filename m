Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936811Ab3DJSBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 14:01:24 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:53965 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765431Ab3DJSBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 14:01:23 -0400
Date: Wed, 10 Apr 2013 11:01:17 -0700
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
        acme@ghostprotocols.net, eranian@google.com, namhyung.kim@lge.com,
        lizefan@huawei.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] perf, cgroup: implement hierarchy support for
 perf_event controller
Message-ID: <20130410180117.GB17641@mtj.dyndns.org>
References: <1365474213-13354-1-git-send-email-tj@kernel.org>
 <1365579146.30071.24.camel@laptop>
 <20130410093755.GC24443@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410093755.GC24443@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Apr 10, 2013 at 11:37:55AM +0200, Ingo Molnar wrote:
> Yeah - at least for larger changes that's a good workflow.
> 
> For smaller changes we can pick one or the other tree. Tejun, do these changes 
> create any conflicts with the current tip:master tree? If not then you could carry 
> these changes in your tree. If there's significant conflicts then it might be 
> better to rebase this on top of perf/core and pull them into perf/core. (assuming 
> there's no other cgroups prereq patches beyond the ones in this series.)

The only conflict is a trivial #include one in
include/linux/res_counter.h which is unrelated to this series.  I'll
commit these to cgroup/for-3.10.

Thanks!

-- 
tejun

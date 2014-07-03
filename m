Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaGCLDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 07:03:11 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37811 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaGCLDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 07:03:08 -0400
Date: Thu, 3 Jul 2014 07:02:38 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Aristeu Rozanski <aris@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/5] cgroup: rename cgroup_subsys->base_cftypes to
 ->legacy_cftypes
Message-ID: <20140703110238.GA9748@hmsreliant.think-freely.org>
References: <1404345055-8196-1-git-send-email-tj@kernel.org>
 <1404345055-8196-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404345055-8196-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 07:50:52PM -0400, Tejun Heo wrote:
> Currently, cgroup_subsys->base_cftypes is used for both the unified
> default hierarchy and legacy ones and subsystems can mark each file
> with either CFTYPE_ONLY_ON_DFL or CFTYPE_INSANE if it has to appear
> only on one of them.  This is quite hairy and error-prone.  Also, we
> may end up exposing interface files to the default hierarchy without
> thinking it through.
> 
> cgroup_subsys will grow two separate cftype arrays and apply each only
> on the hierarchies of the matching type.  This will allow organizing
> cftypes in a lot clearer way and encourage subsystems to scrutinize
> the interface which is being exposed in the new default hierarchy.
> 
> In preparation, this patch renames cgroup_subsys->base_cftypes to
> cgroup_subsys->legacy_cftypes.  This patch is pure rename.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Aristeu Rozanski <aris@redhat.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390Ab3FNBgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 21:36:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:54142 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939Ab3FNBgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 21:36:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,863,1363158000"; 
   d="scan'208";a="349626730"
Date: Fri, 14 Jun 2013 09:36:07 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [cgroup_init_early] WARNING: at mm/percpu.c:292 pcpu_mem_zalloc()
Message-ID: <20130614013607.GA13366@localhost>
References: <20130613230004.GA8096@localhost>
 <51BA6DFD.6060903@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BA6DFD.6060903@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 09:12:29AM +0800, Li Zefan wrote:
> On 2013/6/14 7:00, Fengguang Wu wrote:
> > Greetings,
> > 
> > I got the below dmesg and the first bad commit is
> > 
> > commit f284b77333b1320491f138b76f11006bbc962569
> > Author: Tejun Heo <tj@kernel.org>
> > Date:   Wed Jun 12 13:50:58 2013 -0700
> > 
> >     cgroup: use percpu refcnt for cgroup_subsys_states
> >     
> 
> You were testing the old patch, and Tejun has had it updated yesterday,
> and the new one won't trigger this warning.

Got it, thanks for the quick fix!

Thanks,
Fengguang

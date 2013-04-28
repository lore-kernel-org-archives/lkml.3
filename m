Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab3D1Czl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 22:55:41 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:62990 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab3D1Czk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 22:55:40 -0400
Date: Sat, 27 Apr 2013 19:55:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] cpuset: fix compile warning when CONFIG_SMP=n
Message-ID: <20130428025535.GA6569@htj.dyndns.org>
References: <517C7F91.2030705@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517C7F91.2030705@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 28, 2013 at 09:46:57AM +0800, Li Zefan wrote:
> Reported by Fengguang's kbuild test robot:
> 
> kernel/cpuset.c:787: warning: 'generate_sched_domains' defined but not used
> 
> Introduced by commit e0e80a02e5701c8790bd348ab59edb154fbda60b
> ("cpuset: use rebuild_sched_domains() in cpuset_hotplug_workfn()),
> which removed generate_sched_domains() from cpuset_hotplug_workfn().
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.10.  Thanks.

-- 
tejun

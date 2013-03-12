Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933613Ab3CLVZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:25:53 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:39222 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723Ab3CLVZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:25:51 -0400
Date: Tue, 12 Mar 2013 14:25:47 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cpuset: fix RCU lockdep splat in
 cpuset_print_task_mems_allowed()
Message-ID: <20130312212547.GL25266@htj.dyndns.org>
References: <513E92D7.9050903@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513E92D7.9050903@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 10:28:39AM +0800, Li Zefan wrote:
> Sasha reported a lockdep warning when OOM was triggered. The reason
> is cgroup_name() should be called with rcu_read_lock() held.
> 
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.10.

Thanks.

-- 
tejun

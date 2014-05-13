Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbaEMPfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:35:32 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:43916 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbaEMPes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:34:48 -0400
Date: Tue, 13 May 2014 11:34:45 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: kbuild test robot <fengguang.wu@intel.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH cgroup/for-3.16] cgroup: fix rcu_read_lock() leak in
 update_if_frozen()
Message-ID: <20140513153445.GG23710@htj.dyndns.org>
References: <5369104d.Nn5Lpp7nwOehwnnC%fengguang.wu@intel.com>
 <20140510032941.GE22539@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140510032941.GE22539@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 11:29:41PM -0400, Tejun Heo wrote:
> While updating cgroup_freezer locking, 68fafb77d827 ("cgroup_freezer:
> replace freezer->lock with freezer_mutex") introduced a bug in
> update_if_frozen() where it returns with rcu_read_lock() held.  Fix it
> by adding rcu_read_unlock() before returning.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>

Applied to cgroup/for-3.15-fixes.

Thanks.

-- 
tejun

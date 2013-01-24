Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab3AXUGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:06:23 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:53083 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab3AXUGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:06:15 -0500
Date: Thu, 24 Jan 2013 12:06:09 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 1/6] cgroup: initialize cgrp->dentry before css_alloc()
Message-ID: <20130124200609.GT2373@mtj.dyndns.org>
References: <5100D4FE.9080205@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5100D4FE.9080205@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 02:30:22PM +0800, Li Zefan wrote:
> With this change, we're guaranteed that cgroup_path() won't see NULL
> cgrp->dentry, and thus we can remove the NULL check in it.
> 
> (Well, it's not true, because dummptop.dentry is always NULL)
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Appled 1-6 to cgroup/for-3.9.

Thanks.

-- 
tejun

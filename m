Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab3LLPft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 10:35:49 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:57144 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3LLPfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 10:35:48 -0500
Date: Thu, 12 Dec 2013 10:35:36 -0500
From: Tejun Heo <tj@kernel.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, devel@openvz.org,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] cgroup: fix fail path in cgroup_load_subsys()
Message-ID: <20131212153536.GD32683@htj.dyndns.org>
References: <1386403085-24866-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386403085-24866-1-git-send-email-vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 07, 2013 at 11:58:05AM +0400, Vladimir Davydov wrote:
> We should not call cgroup_unload_subsys() if online_css() fails, because
> online_css() does not assign css to cgroup on failure, while
> offline_css() called from cgroup_unload_subsys() expects it is assigned.
> So let's call everything we need to rollback inline without involving
> cgroup_unload_subsys().
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.13-fixes.

Thanks.

-- 
tejun

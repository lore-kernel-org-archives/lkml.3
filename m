Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab3DGFjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 01:39:09 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:21227 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3DGFjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 01:39:08 -0400
Message-ID: <5161064D.30000@huawei.com>
Date: Sun, 7 Apr 2013 13:38:21 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET] cgroup: unexport locking interface
References: <1365118589-10619-1-git-send-email-tj@kernel.org>
In-Reply-To: <1365118589-10619-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/5 7:36, Tejun Heo wrote:
> Hello,
> 
> Most cgroup_mutex abuses outside cgroup core proper have been
> eradicated but there's still one use remaining and locking interface
> is still exported.  This patchset updates the last user and unexports
> the locking interface and is composed of the following five patches.
> 
>  0001-cgroup-cpuset-replace-move_member_tasks_to_cpuset-wi.patch
>  0002-cgroup-relocate-cgroup_lock_live_group-and-cgroup_at.patch
>  0003-cgroup-unexport-locking-interface-and-cgroup_attach_.patch
>  0004-cgroup-kill-cgroup_-un-lock.patch
>  0005-cgroup-remove-cgroup_lock_is_held.patch
> 

Acked-by: Li Zefan <lizefan@huawei.com>


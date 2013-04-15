Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab3DODoK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 23:44:10 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:30904 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3DODoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 23:44:07 -0400
Message-ID: <516B777B.9050704@huawei.com>
Date: Mon, 15 Apr 2013 11:43:55 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kay@vrfy.org>, <greg@kroah.com>,
        <lennart@poettering.net>, <daniel@zonque.org>
Subject: Re: [PATCHSET] cgroup: implement task_cgroup_path_from_hierarchy()
References: <1365964619-14762-1-git-send-email-tj@kernel.org>
In-Reply-To: <1365964619-14762-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/15 2:36, Tejun Heo wrote:
> kdbus folks want a sane way to determine the cgroup path that a given
> task belongs to on a given hierarchy, which is a reasonble thing to
> expect from cgroup core.
> 
> This patchset make hierarchy_id allocation use idr instead of ida and
> implement task_cgroup_path_from_hierarchy().  In the process, the
> yucky ida cyclic allocation is replaced with idr_alloc_cyclic().
> 
>  0001-cgroup-refactor-hierarchy_id-handling.patch
>  0002-cgroup-drop-hierarchy_id_lock.patch
>  0003-cgroup-make-hierarchy_id-use-cyclic-idr.patch
>  0004-cgroup-implement-task_cgroup_path_from_hierarchy.patch
> 
> 0001-0002 prepare for conversion to idr, which 0003 does.
> 
> 0004 implements the new function.
> 

Acked-by: Li Zefan <lizefan@huawei.com>


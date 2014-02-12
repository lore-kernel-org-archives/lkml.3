Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaBLI7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:59:18 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:26472 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaBLI7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:59:16 -0500
Message-ID: <52FB37D3.4030504@huawei.com>
Date: Wed, 12 Feb 2014 16:58:59 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET v2 cgroup/for-3.15] cgroup: cleanups after kernfs conversion
References: <1391877509-10855-1-git-send-email-tj@kernel.org>
In-Reply-To: <1391877509-10855-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/9 0:38, Tejun Heo wrote:
> Hello,
> 
> This is v2 of cleanups-after-kernfs-conversion patchset.  Nothing
> really changed since the last take[L]. It just got rebased on top of
> the updated patches.
> 
> This patchset does a number of cleanups which are possible now that
> cgroup is converted to kernfs.  This patchset contains the following
> eight patches.
> 
>  0001-cgroup-warn-if-xattr-is-specified-with-sane_behavior.patch
>  0002-cgroup-relocate-cgroup_rm_cftypes.patch
>  0003-cgroup-remove-cftype_set.patch
>  0004-cgroup-simplify-dynamic-cftype-addition-and-removal.patch
>  0005-cgroup-make-cgroup-hold-onto-its-kernfs_node.patch
>  0006-cgroup-remove-cgroup-name.patch
>  0007-cgroup-rename-cgroupfs_root-number_of_cgroups-to-nr_.patch
>  0008-cgroup-remove-cgroupfs_root-refcnt.patch
> 

Ack-by: Li Zefan <lizefan@huawei.com>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3IEDZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 23:25:31 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:15717 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3IEDZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 23:25:30 -0400
Message-ID: <5227F989.10907@huawei.com>
Date: Thu, 5 Sep 2013 11:24:57 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET cgroup/for-3.12] cgroup: factor out css creation into
 create_css()
References: <1377723829-22814-1-git-send-email-tj@kernel.org>
In-Reply-To: <1377723829-22814-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/29 5:03, Tejun Heo wrote:
> Hello,
> 
> For unified hierarchy, a css's (cgroup_subsys_state) lifetime will be
> different from that of the associated cgroup.  css's may be created
> and destroyed dynamically over the lifetime of a single cgroup.  The
> previous changes decoupled css destruction from cgroup's.  This
> patchset decouples css creation from cgroup's.
> 
> This patchset contains the following nine patches.
> 
>  0001-cgroup-fix-css-leaks-on-online_css-failure.patch
>  0002-cgroup-css-iterations-and-css_from_dir-are-safe-unde.patch
>  0003-cgroup-make-for_each_subsys-useable-under-cgroup_roo.patch
>  0004-cgroup-move-css_id-commit-from-cgroup_populate_dir-t.patch
>  0005-cgroup-reorder-operations-in-cgroup_create.patch
>  0006-cgroup-combine-css-handling-loops-in-cgroup_create.patch
>  0007-cgroup-factor-out-cgroup_subsys_state-creation-into-.patch
>  0008-cgroup-implement-for_each_css.patch
>  0009-cgroup-remove-for_each_root_subsys.patch
> 

Acked-by: Li Zefan <lizefan@huawei.com>


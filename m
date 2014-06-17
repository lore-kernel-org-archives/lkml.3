Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933600AbaFQT01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:26:27 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58132 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657AbaFQT0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:26:25 -0400
Date: Tue, 17 Jun 2014 15:26:21 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 1/5] cgroup: fix broken css_has_online_children()
Message-ID: <20140617192621.GO31819@htj.dyndns.org>
References: <53994943.60703@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53994943.60703@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 02:31:31PM +0800, Li Zefan wrote:
> After running:
> 
>   # mount -t cgroup cpu xxx /cgroup && mkdir /cgroup/sub && \
>     rmdir /cgroup/sub && umount /cgroup
> 
> I found the cgroup root still existed:
> 
>   # cat /proc/cgroups
>   #subsys_name    hierarchy       num_cgroups     enabled
>   cpuset  0       1       1
>   cpu     1       1       1
>   ...
> 
> It turned out css_has_online_children() is broken.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.16-fixes.

Thanks.

-- 
tejun

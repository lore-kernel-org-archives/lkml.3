Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126Ab3HMO5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:57:40 -0400
Received: from mail-gh0-f173.google.com ([209.85.160.173]:45407 "EHLO
	mail-gh0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976Ab3HMO5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:57:37 -0400
Date: Tue, 13 Aug 2013 10:57:33 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH][3.11] cpuset: fix the return value of cpuset_write_u64()
Message-ID: <20130813145733.GD26596@mtj.dyndns.org>
References: <52099487.8010601@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52099487.8010601@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 10:05:59AM +0800, Li Zefan wrote:
> Writing to this file always returns -ENODEV:
> 
>   # echo 1 > cpuset.memory_pressure_enabled
>   -bash: echo: write error: No such device
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> Cc: <stable@vger.kernel.org> # 3.9+

Applied to cgroup/for-3.11-fixes.  Thanks.

-- 
tejun

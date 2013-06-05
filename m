Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab3FEU53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:57:29 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:47672 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347Ab3FEU50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:57:26 -0400
Date: Wed, 5 Jun 2013 13:57:21 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH v2 05/10] cpuset: re-structure update_cpumask() a bit
Message-ID: <20130605205721.GJ10693@mtj.dyndns.org>
References: <51AF0183.8070602@huawei.com>
 <51AF01CF.1070706@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AF01CF.1070706@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 05:15:59PM +0800, Li Zefan wrote:
> Check if cpus_allowed is to be changed before calling validate_change().
> 
> This won't change any behavior, but later it will allow us to do this:
> 
>  # mkdir /cpuset/child
>  # echo $$ > /cpuset/child/tasks	/* empty cpuset */
>  # echo > /cpuset/child/cpuset.cpus	/* do nothing, won't fail */
> 
> Without this patch, the last operation will fail.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied 1-5 to cgroup/for-3.11-cpuset.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.11-cpuset

Thanks.

-- 
tejun

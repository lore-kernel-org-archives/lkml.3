Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab3CMGd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 02:33:26 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:60060 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab3CMGdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 02:33:22 -0400
Message-ID: <51401DAB.1070602@huawei.com>
Date: Wed, 13 Mar 2013 14:33:15 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Tejun Heo <tj@kernel.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (cgroup
 tree related)
References: <20130313161236.760c25633a4e8ea8d4847ccb@canb.auug.org.au>
In-Reply-To: <20130313161236.760c25633a4e8ea8d4847ccb@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/13 13:12, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allnoconfig) failed like this:
> 
> In file included from include/linux/memcontrol.h:22:0,
>                  from include/linux/swap.h:8,
>                  from include/linux/suspend.h:4,
>                  from arch/powerpc/kernel/asm-offsets.c:24:
> include/linux/cgroup.h:748:13: warning: 'struct cgroupstats' declared inside parameter list [enabled by default]
> include/linux/cgroup.h:748:13: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
> cc1: all warnings being treated as errors
> 
> and many more similar.
> 
> Caused by commit c2c9ad164fa3 ("cgroup: remove unneeded includes from
> cgroup.h").
> 

Tejun has dropped this patch.


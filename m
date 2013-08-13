Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab3HMCHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 22:07:49 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:19136 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab3HMCHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 22:07:48 -0400
Message-ID: <520994C5.5050503@huawei.com>
Date: Tue, 13 Aug 2013 10:07:01 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpuset: remove redundant checks in file write functions
References: <5209892D.8070502@huawei.com> <52098941.4070600@huawei.com>
In-Reply-To: <52098941.4070600@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/13 9:17, Li Zefan wrote:
> Now cgroup core gets a reference to the css when a cgroup file is
> opened(), and the reference is dropped at file release. so it's
> guaranteed the cpuset is online during the write function.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
>  kernel/cpuset.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 

Please don't apply this patch. I'll send a new one when the bug
fix I just sent is accepted.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab3BDCup (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 21:50:45 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:47888 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab3BDCun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 21:50:43 -0500
Message-ID: <510F21B9.4000604@huawei.com>
Date: Mon, 4 Feb 2013 10:49:29 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <rusty@rustcorp.com.au>, <bfields@fieldses.org>,
        <skinsbursky@parallels.com>, <ebiederm@xmission.com>,
        <jmorris@namei.org>, <axboe@kernel.dk>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>
Subject: Re: [PATCH 55/62] cgroup: convert to idr_alloc()
References: <1359854463-2538-1-git-send-email-tj@kernel.org> <1359854463-2538-56-git-send-email-tj@kernel.org>
In-Reply-To: <1359854463-2538-56-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/2/3 9:20, Tejun Heo wrote:
> Convert to the much saner new idr interface.
> 
> Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Looks good to me.

Acked-by: Li Zefan <lizefan@huawei.com>

> Cc: Li Zefan <lizefan@huawei.com>
> Cc: containers@lists.linux-foundation.org
> Cc: cgroups@vger.kernel.org
> ---
> This patch depends on an earlier idr changes and I think it would be
> best to route these together through -mm.  Please holler if there's
> any objection.  Thanks.
> 
>  kernel/cgroup.c | 27 ++++++++-------------------
>  1 file changed, 8 insertions(+), 19 deletions(-)
> 


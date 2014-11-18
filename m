Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbaKRGfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 01:35:31 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:15679 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaKRGf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 01:35:29 -0500
Message-ID: <546AE8A9.1090600@huawei.com>
Date: Tue, 18 Nov 2014 14:35:21 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3 cgroup/for-3.19] cgroup: implement cgroup_get_e_css()
References: <20141117205652.GA23126@htj.dyndns.org> <20141117205734.GB23126@htj.dyndns.org> <20141117205855.GC23126@htj.dyndns.org>
In-Reply-To: <20141117205855.GC23126@htj.dyndns.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/18 4:58, Tejun Heo wrote:
> Implement cgroup_get_e_css() which finds and gets the effective css
> for the specified cgroup and subsystem combination.  This function
> always returns a valid pinned css.  This will be used by cgroup
> writeback support.
> 
> While at it, add comment to cgroup_e_css() to explain why that
> function is different from cgroup_get_e_css() and has to test
> cgrp->child_subsys_mask instead of cgroup_css(cgrp, ss).
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

For all 3 patches:

Acked-by: Zefan Li <lizefan@huawei.com>


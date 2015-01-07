Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbbAGD5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 22:57:22 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:9531 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbbAGD5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 22:57:21 -0500
Message-ID: <54ACAE8D.4030807@huawei.com>
Date: Wed, 7 Jan 2015 11:57:01 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 cgroup/for-3.20] cgroup: reorder SUBSYS(blkio) in
 cgroup_subsys.h
References: <20150106165720.GI3077@htj.dyndns.org>
In-Reply-To: <20150106165720.GI3077@htj.dyndns.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/7 0:57, Tejun Heo wrote:
> The scheduled cgroup writeback support requires blkio to be
> initialized before memcg as memcg needs to provide certain blkcg
> related functionalities.  Relocate blkio so that it's right above
> memory.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> Hello,
> 
> These are two trivial patches to prepare for the cgroup writeback
> support.  Applying to cgroup/for-3.20.
> 

Acked-by: Zefan Li <lizefan@huawei.com>


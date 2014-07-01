Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbaGABwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 21:52:50 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:3014 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaGABws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 21:52:48 -0400
Message-ID: <53B21468.8090500@huawei.com>
Date: Tue, 1 Jul 2014 09:52:40 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH cgroup/for-3.16-fixes] cpuset: break kernfs active protection
 in cpuset_write_resmask()
References: <53B0DD8D.5060805@huawei.com> <20140630194732.GF14807@htj.dyndns.org>
In-Reply-To: <20140630194732.GF14807@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020208.53B2146D.00D5,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 7e153c03bc35274efa83407e896dd73f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/1 3:47, Tejun Heo wrote:
> Hey, Li.
> 
> Can you please test this patch and ack it?
> 
...
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Li Zefan <lizefan@huawei.com>

Tested-by: Li Zefan <lizefan@huawei.com>

Thanks!

> ---
>  kernel/cpuset.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)


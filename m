Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955Ab3FSBbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:31:24 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:53305 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab3FSBbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:31:22 -0400
Message-ID: <51C109DE.8010607@huawei.com>
Date: Wed, 19 Jun 2013 09:31:10 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH ] cgroup: rename cont to cgrp
References: <51BA8B3F.3060606@huawei.com>
In-Reply-To: <51BA8B3F.3060606@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Could you apply this patch?

On 2013/6/14 11:17, Li Zefan wrote:
> Cont is short for container. control group was named process container
> at first, but then people found container already has a meaning in
> linux kernel.
> 
> Clean up the leftover variable name @cont.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
> 
> I'll clean up this for memcg later.
> 
> ---
>  include/linux/cgroup.h |  4 ++--
>  kernel/cgroup.c        | 22 +++++++++++-----------
>  2 files changed, 13 insertions(+), 13 deletions(-)
> 


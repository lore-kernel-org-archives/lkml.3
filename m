Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204Ab3FNBMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 21:12:40 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:2772 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab3FNBMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 21:12:38 -0400
Message-ID: <51BA6DFD.6060903@huawei.com>
Date: Fri, 14 Jun 2013 09:12:29 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Tejun Heo <tj@kernel.org>, <cgroups@vger.kernel.org>,
        <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [cgroup_init_early] WARNING: at mm/percpu.c:292 pcpu_mem_zalloc()
References: <20130613230004.GA8096@localhost>
In-Reply-To: <20130613230004.GA8096@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/14 7:00, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> commit f284b77333b1320491f138b76f11006bbc962569
> Author: Tejun Heo <tj@kernel.org>
> Date:   Wed Jun 12 13:50:58 2013 -0700
> 
>     cgroup: use percpu refcnt for cgroup_subsys_states
>     

You were testing the old patch, and Tejun has had it updated yesterday,
and the new one won't trigger this warning.


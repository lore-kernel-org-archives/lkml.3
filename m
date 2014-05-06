Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539AbaEFBWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:22:11 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:9091 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933432AbaEFBWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:22:10 -0400
Message-ID: <53683933.80707@huawei.com>
Date: Tue, 6 May 2014 09:21:55 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] kernel/cpuset.c: kernel-doc fixes
References: <20140505194655.6d1304a0826c107debdbbe30@skynet.be>
In-Reply-To: <20140505194655.6d1304a0826c107debdbbe30@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/6 1:46, Fabian Frederick wrote:
> This patch also converts seq_printf to seq_puts
> 
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Acked-by: Li Zefan <lizefan@huawei.com>

> ---
>  kernel/cpuset.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
...
>  void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task)
>  {
> -	seq_printf(m, "Mems_allowed:\t");
> +	seq_puts(m, "Mems_allowed:\t");
>  	seq_nodemask(m, &task->mems_allowed);
> -	seq_printf(m, "\n");
> -	seq_printf(m, "Mems_allowed_list:\t");
> +	seq_puts(m, "\n");

will seq_putc() produce slightly smaller code?

> +	seq_puts(m, "Mems_allowed_list:\t");
>  	seq_nodemask_list(m, &task->mems_allowed);
> -	seq_printf(m, "\n");
> +	seq_puts(m, "\n");
>  }
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab3JRDK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 23:10:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39638 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab3JRDK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 23:10:56 -0400
Message-ID: <5260A6B0.4070509@infradead.org>
Date: Thu, 17 Oct 2013 20:10:40 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Xie XiuQi <xiexiuqi@huawei.com>, Jiri Kosina <trivial@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] irq: Fix some trivial typos in comments
References: <52608AB1.1010307@huawei.com> <52608AE4.9060304@huawei.com>
In-Reply-To: <52608AE4.9060304@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/13 18:12, Xie XiuQi wrote:
> Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
> ---
>  kernel/irq/chip.c   |    2 +-
>  kernel/irq/manage.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index a3bb14f..dc04c16 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -214,7 +214,7 @@ void irq_enable(struct irq_desc *desc)
>  }
> 
>  /**
> - * irq_disable - Mark interupt disabled
> + * irq_disable - Mark interrupt disabled
>   * @desc:	irq descriptor which should be disabled
>   *
>   * If the chip does not implement the irq_disable callback, we
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 514bcfd..6394a3c 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -786,7 +786,7 @@ irq_forced_thread_fn(struct irq_desc *desc, struct irqaction *action)
>  }
> 
>  /*
> - * Interrupts explicitely requested as threaded interupts want to be
> + * Interrupts explicitely requested as threaded interrupts want to be

                 explicitly

>   * preemtible - many of them need to sleep and wait for slow busses to
>   * complete.
>   */
> 


-- 
~Randy

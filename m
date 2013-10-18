Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab3JRXcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 19:32:39 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:35268 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab3JRXci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 19:32:38 -0400
Message-ID: <5261C513.3050100@linaro.org>
Date: Fri, 18 Oct 2013 16:32:35 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Xie XiuQi <xiexiuqi@huawei.com>, Jiri Kosina <trivial@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] timekeeping: Fix some trivial typos in comments
References: <52608AB1.1010307@huawei.com> <52608B3A.7050808@huawei.com>
In-Reply-To: <52608B3A.7050808@huawei.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2013 06:13 PM, Xie XiuQi wrote:
> Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
> ---
>  kernel/time/timekeeping.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 947ba25..3abf534 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -1613,9 +1613,10 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
>   * ktime_get_update_offsets - hrtimer helper
>   * @offs_real:	pointer to storage for monotonic -> realtime offset
>   * @offs_boot:	pointer to storage for monotonic -> boottime offset
> + * @offs_tai:	pointer to storage for monotonic -> clock tai offset
>   *
>   * Returns current monotonic time and updates the offsets
> - * Called from hrtimer_interupt() or retrigger_next_event()
> + * Called from hrtimer_interrupt() or retrigger_next_event()
>   */
>  ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
>  							ktime_t *offs_tai)

Even though its trivial, next time please add some sort of commit
message, even if its redundent to the commit subject.

Queued in my 3.13 branch.

thanks
-john


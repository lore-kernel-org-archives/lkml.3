Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaKDOjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:39:16 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:50186 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751847AbaKDOjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:39:15 -0500
Date: Tue, 4 Nov 2014 09:39:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "pang.xunlei" <pang.xunlei@linaro.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH v2 3/6] sched/cpupri: Remove unnecessary definitions in
 cpupri.h
Message-ID: <20141104093913.392d2ed2@gandalf.local.home>
In-Reply-To: <1415099585-31174-3-git-send-email-pang.xunlei@linaro.org>
References: <1415099585-31174-1-git-send-email-pang.xunlei@linaro.org>
	<1415099585-31174-3-git-send-email-pang.xunlei@linaro.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Nov 2014 19:13:02 +0800
"pang.xunlei" <pang.xunlei@linaro.org> wrote:

> Actually, cpupri_set() and cpupri_init() can never be used without
> CONFIG_SMP.
> 

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
> ---
>  kernel/sched/cpupri.h |    3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/kernel/sched/cpupri.h b/kernel/sched/cpupri.h
> index 6b03334..63cbb9c 100644
> --- a/kernel/sched/cpupri.h
> +++ b/kernel/sched/cpupri.h
> @@ -26,9 +26,6 @@ int  cpupri_find(struct cpupri *cp,
>  void cpupri_set(struct cpupri *cp, int cpu, int pri);
>  int cpupri_init(struct cpupri *cp);
>  void cpupri_cleanup(struct cpupri *cp);
> -#else
> -#define cpupri_set(cp, cpu, pri) do { } while (0)
> -#define cpupri_init() do { } while (0)
>  #endif
>  
>  #endif /* _LINUX_CPUPRI_H */


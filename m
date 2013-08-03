Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3HCVcS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 17:32:18 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54223 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab3HCVcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 17:32:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        l.majewski@samsung.com
Subject: Re: [PATCH 01/10] cpufreq: Cleanup header files included in core
Date: Sat, 03 Aug 2013 23:42:30 +0200
Message-ID: <2013377.ZVFroF3AQ6@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohponCtLRi1UJCN0z2hRVH=o326mtS2nUEvoi8Rf5H==vATw@mail.gmail.com>
References: <cover.1375530162.git.viresh.kumar@linaro.org> <fe67f3269a07123b025468214e692af573b07364.1375530162.git.viresh.kumar@linaro.org> <CAKohponCtLRi1UJCN0z2hRVH=o326mtS2nUEvoi8Rf5H==vATw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 03, 2013 10:45:04 PM Viresh Kumar wrote:
> On 3 August 2013 17:19, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > This patch intends to cleanup following issues in the header files included in
> > cpufreq core layers:
> > - Include headers in ascending order, so that we don't add same multiple times
> >   by mistake.
> > - <asm/> must be included after <linux/>, so that they override whatever they
> >   need.
> > - Remove unnecessary header files
> > - Don't include files already included by cpufreq.h or cpufreq_governor.h
> >
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> Fixup due to compilation warning reported by Fengguang's kbuild system:
> [Latest stuff pushed in my cpufreq-next branch]
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 70399ea..ccaf025 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -19,6 +19,7 @@
> 
>  #include <linux/cpu.h>
>  #include <linux/cpufreq.h>
> +#include <linux/delay.h>
>  #include <linux/device.h>
>  #include <linux/init.h>
>  #include <linux/kernel_stat.h>

Can you please repost the complete patch with this folded in?

Rafael


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab3GLGFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 02:05:09 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:54075 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab3GLGFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 02:05:06 -0400
MIME-Version: 1.0
In-Reply-To: <1373571281-4457-1-git-send-email-aaro.koskinen@iki.fi>
References: <1373571281-4457-1-git-send-email-aaro.koskinen@iki.fi>
Date: Fri, 12 Jul 2013 11:35:05 +0530
X-Google-Sender-Auth: UXFwICWKPs-OPNYVJbIrfI0anDQ
Message-ID: <CAOh2x==snAt8UfdG+d_FvA6m9Pqnp_BmonOB=u7UX1MLH8O89A@mail.gmail.com>
Subject: Re: [PATCH] MIPS: loongson2: cpufreq: fix broken cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ralf Baechle <ralf@linux-mips.org>,
        cpufreq@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 1:04 AM, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
> Commit 42913c799 (MIPS: Loongson2: Use clk API instead of direct
> dereferences) broke the cpufreq functionality on Loongson2 boards:
> clk_set_rate() is called before the CPU frequency table is initialized,
> and therefore will always fail.
>
> Fix by moving the clk_set_rate() after the table initialization.
> Tested on Lemote FuLoong mini-PC.
>
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> Cc: stable@vger.kernel.org
> ---
>  drivers/cpufreq/loongson2_cpufreq.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)

Ackec-by: Viresh Kumar <viresh.kumar@linaro.org>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbaB1DsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 22:48:06 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:52680 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaB1DsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 22:48:03 -0500
MIME-Version: 1.0
In-Reply-To: <1393552716-9754-1-git-send-email-skannan@codeaurora.org>
References: <1393552716-9754-1-git-send-email-skannan@codeaurora.org>
Date: Fri, 28 Feb 2014 09:18:02 +0530
Message-ID: <CAKohpomjtE7Rtrs-TgxtSo658+4p0AHLzr9niN1GnkkrDqTxTw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] cpufreq: stats: Remove redundant cpufreq_cpu_get() call
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 February 2014 07:28, Saravana Kannan <skannan@codeaurora.org> wrote:
> __cpufreq_stats_create_table always gets pass the valid and real policy
> struct. So, there's no need to call cpufreq_cpu_get() to get the policy
> again.
>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> ---
>  drivers/cpufreq/cpufreq_stats.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)

All patches look fine now. Rafael you can queue them up as per your
convenience.

@Saravana: Though I am quite sure you still need my patches to get
your initial issue fixed. So, can you please get them tested as early
as possible, so that we can get them in for 3.14?

@Srivatsa: Your reviews will also help :)

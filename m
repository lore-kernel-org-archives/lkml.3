Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3F0I6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:58:17 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:44879 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab3F0I6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:58:12 -0400
MIME-Version: 1.0
In-Reply-To: <1371661969-7660-5-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1371661969-7660-1-git-send-email-l.majewski@samsung.com>
	<1371661969-7660-5-git-send-email-l.majewski@samsung.com>
Date: Thu, 27 Jun 2013 14:28:11 +0530
Message-ID: <CAKohpokf8TZkP5Nzpp+m5KaUK8zJ6mwiuiW-td7boHQ7NtB-DQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/7] cpufreq:exynos:Extend Exynos cpufreq driver to
 support boost framework
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 June 2013 22:42, Lukasz Majewski <l.majewski@samsung.com> wrote:
> The struct cpufreq_driver has been extended to embrace the information
> related to boost support.
>
> When "boost_mode" device tree attribute is defined for a platform, the
> boost_supported flag is set. Moreover boost related attributes were
> exported.
>
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>
> Changes for v4:
> - None
>
> Changes for v3:
> - Remove low level boost code
> - Move boost management code to cpufreq core code
> - Use boost_supported flag to indicate if driver supports over clocking
>
> Changes for v2:
> - Removal of struct cpufreq_boost
> - Removal of the CONFIG_CPU_FREQ_BOOST flag
> - low_level_boost with valid address when boost is supported
> ---
>  drivers/cpufreq/exynos-cpufreq.c |    4 ++++
>  1 file changed, 4 insertions(+)

Yes, this looks fine..

I will Ack the whole series in the end, so no individual acks :)

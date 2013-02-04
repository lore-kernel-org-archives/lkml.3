Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab3BDMWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:22:06 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:59106 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab3BDMWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 07:22:05 -0500
MIME-Version: 1.0
In-Reply-To: <f216e85846c302756d55cb6753863a66697f79a6.1359599087.git.viresh.kumar@linaro.org>
References: <f216e85846c302756d55cb6753863a66697f79a6.1359599087.git.viresh.kumar@linaro.org>
Date: Mon, 4 Feb 2013 17:52:03 +0530
Message-ID: <CAKohpo=aWbJ9a9vKep1aGYTXr=5asYPCri1BPCww-3GxEo8F=w@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: exynos: simplify .init() for setting policy->cpus
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, jc.lee@samsung.com
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        kgene.kim@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 January 2013 07:56, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> With the recent changes in cpufreq core, we just need to set mask of all
> possible cpus into policy->cpus. Rest would be done by core.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/exynos-cpufreq.c | 14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)

Hi Rafael,

Are you picking up this patch ?

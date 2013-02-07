Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367Ab3BGFSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 00:18:09 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:37074 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab3BGFSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 00:18:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpo=aWbJ9a9vKep1aGYTXr=5asYPCri1BPCww-3GxEo8F=w@mail.gmail.com>
References: <f216e85846c302756d55cb6753863a66697f79a6.1359599087.git.viresh.kumar@linaro.org>
	<CAKohpo=aWbJ9a9vKep1aGYTXr=5asYPCri1BPCww-3GxEo8F=w@mail.gmail.com>
Date: Thu, 7 Feb 2013 10:48:05 +0530
Message-ID: <CAKohpokJn5892Vt-M+5zNoe3Ebc5cOm-K7c1FzK7x2Ws=ysYmQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: exynos: simplify .init() for setting policy->cpus
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, jc.lee@samsung.com,
        Inderpal Singh <inderpal.singh@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        kgene.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 February 2013 17:52, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 31 January 2013 07:56, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> With the recent changes in cpufreq core, we just need to set mask of all
>> possible cpus into policy->cpus. Rest would be done by core.
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>  drivers/cpufreq/exynos-cpufreq.c | 14 +-------------
>>  1 file changed, 1 insertion(+), 13 deletions(-)
>
> Hi Rafael,
>
> Are you picking up this patch ?

Ping!!

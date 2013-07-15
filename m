Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab3GOKCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:02:11 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:35893 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab3GOKCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:02:08 -0400
MIME-Version: 1.0
In-Reply-To: <51DD1BB6.3080304@samsung.com>
References: <1373014001-17746-1-git-send-email-cw00.choi@samsung.com>
	<1373014001-17746-2-git-send-email-cw00.choi@samsung.com>
	<CAKohpomriPXmK3TRFqinyEEuG39O1ppKmPuW0gvs3iRLnsoPrg@mail.gmail.com>
	<51DD1BB6.3080304@samsung.com>
Date: Mon, 15 Jul 2013 15:32:08 +0530
Message-ID: <CAKohpo=jZeF=Gjg3CfsRoAUwyMkSTUTVcmD=ygFYMbM2s6YwPw@mail.gmail.com>
Subject: Re: [PATCH 1/6] cpufreq: Add debugfs directory for cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 July 2013 14:00, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> On 07/09/2013 06:23 PM, Viresh Kumar wrote:
>> On 5 July 2013 14:16, Chanwoo Choi <cw00.choi@samsung.com> wrote:

>>> +static struct dentry *cpufreq_debugfs;
>>
>> Probably make this dependent on CONFIG_CPU_FREQ_STAT?
>
> I thought that '/sys/kernel/debug/cpufreq' is always created in the same as sysfs file
> when added cpufreq driver. Only the debugfs file(/sys/kernel/debug/cpufreq/load_table)
> has the dependency on CONFIG_CPU_FREQ_STAT.
>
> If *cpufreq_debugfs has the dependency on CONFIG_CPU_FREQ_STAT,
> I should add checking statement with '#ifdef CONFIG_CPU_FREQ_STAT' keyword in cpufreq.c.
>
> What is your opinion to add the dependency of CONFIG_CPU_FREQ_STAT
> in cpufreq.c?

I thought this is yet another piece of stats that we may or maynot use. And
it should be configurable if user wants it or not. So, probably you need
to have dependency on CONFIG_CPU_FREQ_STAT

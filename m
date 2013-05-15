Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540Ab3EOQYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:24:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59698 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243Ab3EOQY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:24:29 -0400
Message-ID: <5193B6B6.3010205@wwwdotorg.org>
Date: Wed, 15 May 2013 10:24:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Sekhar Nori <nsekhar@ti.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Olof Johansson <olof@lixom.net>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH V1 resend] cpufreq: Raname index as data in cpufreq_frequency_table
References: <7e12acada8adcba5f4eb72f6c49e38aaf00a294f.1368434974.git.viresh.kumar@linaro.org> <5191148E.7050205@wwwdotorg.org> <CAKohpo=MS6D9DGiZDUPPYA47c=tqWXUMC6bdssD5xL=7GEcDvw@mail.gmail.com> <51926325.2050805@wwwdotorg.org> <CAKohponZaka9MCfnHAq602oQ42+SR7D1oM6ggODHAzQy==Y4WQ@mail.gmail.com>
In-Reply-To: <CAKohponZaka9MCfnHAq602oQ42+SR7D1oM6ggODHAzQy==Y4WQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 12:25 AM, Viresh Kumar wrote:
> On 14 May 2013 21:45, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 05/14/2013 07:46 AM, Viresh Kumar wrote:
>> ...
>>> This must address your concerns:
>>> @Rafael: I have attached both patches now for you to apply.
>>>
>>> From: Viresh Kumar <viresh.kumar@linaro.org>
>>> Date: Tue, 14 May 2013 19:08:50 +0530
>>> Subject: [PATCH 1/2] cpufreq: tegra: Remove irrelevant comment
>>>
>>> Tegra cpufreq driver doesn't use .index field of cpufreq_frequency_table and so
>>> comment mentioning order of .index is irrelevant. Remove it.
>>
>>> diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
>>
>>> -/* Frequency table index must be sequential starting at 0 */
>>>  static struct cpufreq_frequency_table freq_table[] = {
>>>       { 0, 216000 },
>>>       { 1, 312000 },
>>
>> Does the .index/.data field even need to be filled in any more?
> 
> No. But i didn't wanted to write following code: { .frequency = *** }, as
> earlier one was fine too.
> 
> Ack whichever version you want (Attached too):
...
> Subject: [PATCH] cpufreq: tegra: Don't initialize .index field of
>  cpufreq_frequency_table
> 
> Tegra cpufreq driver doesn't use .index field of cpufreq_frequency_table and so
> we don't need to initialize it. Don't initialize it.

This one looks good.

Acked-by: Stephen Warren <swarren@nvidia.com>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722AbaGIPZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:25:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34297 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932695AbaGIPZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:25:09 -0400
Message-ID: <53BD5EBF.2020007@ti.com>
Date: Wed, 9 Jul 2014 11:24:47 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Shawn Guo <shawn.guo@linaro.org>,
        Nishanth Menon <nm@ti.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Sachin Kamat <spk.linux@gmail.com>
Subject: Re: [PATCH 04/14] cpufreq: cpu0: Add Module Author
References: <cover.1404231535.git.viresh.kumar@linaro.org>	<bc183ef08321e2699a0834d545bade9c7f7d7fcc.1404231535.git.viresh.kumar@linaro.org>	<53BD54BC.7080608@ti.com> <CAKohpomWizkJh-=S1BXKLLM1u891VCmJASxmoSVF+Qy7VMy8Fg@mail.gmail.com>
In-Reply-To: <CAKohpomWizkJh-=S1BXKLLM1u891VCmJASxmoSVF+Qy7VMy8Fg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2014 11:08 AM, Viresh Kumar wrote:
> On 9 July 2014 20:12, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
>> Not related to this patch but I think its time to change
>> the name of this driver. I never liked this 'cpufreq-cpu0.c'
>> and already mentioned that during the reviews of this
>> driver.
>>
>> Not sure if there are still sentiments about it but
>> considering the additional functionality coming in,
>> the name will definitely miss-leading.
> 
> Check last patch, its called cpufreq-generic now.
> 
Sounds good :)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964972AbaGIPaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:30:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52454 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932566AbaGIPaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:30:05 -0400
Message-ID: <53BD5FE8.5040500@ti.com>
Date: Wed, 9 Jul 2014 11:29:44 -0400
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
        Sachin Kamat <spk.linux@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 09/14] cpufreq: cpu0: Move per-cluster initialization
 code to ->init()
References: <cover.1404231535.git.viresh.kumar@linaro.org>	<b26946cc4573904cd1ef0212ad053a983b547c23.1404231535.git.viresh.kumar@linaro.org>	<53BD576F.2010408@ti.com>	<CAKohpokz4eyw86Uxp_aA=9T9x-X=kTV=_=zx4dEuC2ZyR=3pKw@mail.gmail.com>	<53BD5F0C.2050509@ti.com> <CAKohpokOMs3V250wyWB=wdW6SQEcj+RUQaQZk5MYikUKqF6Nsg@mail.gmail.com>
In-Reply-To: <CAKohpokOMs3V250wyWB=wdW6SQEcj+RUQaQZk5MYikUKqF6Nsg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2014 11:27 AM, Viresh Kumar wrote:
> On 9 July 2014 20:56, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
>>>> We still *don't* support platforms with separate clock/voltage lines for CPUs.
>>>> This would be done in a separate patch.
> 
> Probably s/separate/later would be enough to make you happy ?
> 
For reviewer, its easy if this later is "in the current series" or
really a "later" series.
Anyway I understood it now, so its upto you.

regards,
Santosh



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab3LQKrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 05:47:32 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19261 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3LQKra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 05:47:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 17 Dec 2013 02:48:52 -0800
Message-ID: <52B02BD3.906@nvidia.com>
Date: Tue, 17 Dec 2013 18:47:47 +0800
From: bilhuang <bilhuang@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] Remodel Tegra cpufreq drivers to support Tegra
 series SoC
References: <1386229462-3474-1-git-send-email-bilhuang@nvidia.com> <CAKohponJAU20MQ92y4VaOXbsOOmxz6K=349KCq91c5=P=zQOQQ@mail.gmail.com>
In-Reply-To: <CAKohponJAU20MQ92y4VaOXbsOOmxz6K=349KCq91c5=P=zQOQQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 02:26 PM, Viresh Kumar wrote:
> On 5 December 2013 13:14, Bill Huang <bilhuang@nvidia.com> wrote:
>> This patch series remodel Tegra cpufreq driver to make it more easy to
>> add new SoC support, in addition to that, adding probe function in the
>> driver to let probe defer can be used to control init sequence when we
>> are going to support DVFS.
>>
>> Changes since v2:
>>
>> - Fix Kconfig.
>> - Rebase on top of branch 'cpufreq-next' on git://git.linaro.org/people/vireshk/linux.git.
>
> That's wrong base.. This branch is used only for Rafael to pull in
> stuff and so it doesn't
> get updated everyday..
>
> You must rebase on Rafael's linux-next branch all the time.
>
OK thanks, is it branch pm-cpufreq?

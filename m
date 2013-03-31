Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab3CaQkq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 12:40:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47177 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab3CaQko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 12:40:44 -0400
Date: Sun, 31 Mar 2013 12:40:40 -0400 (EDT)
Message-Id: <20130331.124040.1451284849991873230.davem@davemloft.net>
To: viresh.kumar@linaro.org
Cc: rjw@sisk.pl, arvind.chauhan@arm.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, arnd.bergmann@linaro.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH 8/9] spark: cpufreq: move cpufreq driver to
 drivers/cpufreq
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAKohpokGRPJGPh8e_NjpZQRTWOxk=SGzhcNbjkHWAKE-Gfig9g@mail.gmail.com>
References: <CAKohpomnOaVG1xktDL=YGz6yM2vFoYVF2Un-9_zL7owiJVG6gw@mail.gmail.com>
	<CAKohponJJKDcFXK-Zs-eCS2=v3=-CrkEqF1FaHz64D-kq888BA@mail.gmail.com>
	<CAKohpokGRPJGPh8e_NjpZQRTWOxk=SGzhcNbjkHWAKE-Gfig9g@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 31 Mar 2013 09:40:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Sun, 31 Mar 2013 13:00:21 +0530

> On 26 March 2013 09:55, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> From: Viresh Kumar <viresh.kumar@linaro.org>
>> Date: Mon, 25 Mar 2013 11:20:23 +0530
>> Subject: [PATCH] sparc: cpufreq:  move cpufreq driver to drivers/cpufreq
>>
>> This patch moves cpufreq driver of SPARC architecture to drivers/cpufreq.
>>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: sparclinux@vger.kernel.org
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>  arch/sparc/Kconfig                                 | 23 ----------------------
>>  arch/sparc/kernel/Makefile                         |  3 ---
>>  drivers/cpufreq/Kconfig                            | 23 ++++++++++++++++++++++
>>  drivers/cpufreq/Makefile                           |  2 ++
>>  .../cpufreq/sparc-us2e-cpufreq.c                   |  0
>>  .../cpufreq/sparc-us3-cpufreq.c                    |  0
>>  6 files changed, 25 insertions(+), 26 deletions(-)
>>  rename arch/sparc/kernel/us2e_cpufreq.c =>
>> drivers/cpufreq/sparc-us2e-cpufreq.c (100%)
>>  rename arch/sparc/kernel/us3_cpufreq.c =>
>> drivers/cpufreq/sparc-us3-cpufreq.c (100%)
> 
> Hi David,
> 
> Does this one look fine to you?

Subject line still has the "spark" typo.

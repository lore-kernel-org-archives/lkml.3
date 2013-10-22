Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab3JVVGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:06:12 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:49796 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab3JVVGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:06:11 -0400
Date: Tue, 22 Oct 2013 17:06:08 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [PATCH 0/4] CPUFreq stats: Bug fixes
In-Reply-To: <cover.1380190886.git.viresh.kumar@linaro.org>
Message-ID: <alpine.LFD.2.03.1310221659450.1951@syhkavp.arg>
References: <cover.1380190886.git.viresh.kumar@linaro.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Sep 2013, Viresh Kumar wrote:

> There are several problems/bugs in cpufreq-stats specially with cpufreq drivers
> as modules and suspend/resume path. These are mentioned well in changelogs.
> 
> These are tested over my thinkpad (acpi-cpufreq) in following way:
> [1] offline+online all CPUs except boot cpu in a while loop
> [2] then do suspend resume
> [3] repeat [1] and [2] several times.
> 
> No issues found..
> 
> Also tested on my exynos board:
> - Added cpufreq_unregister/register while loop in exynos-cpufreq.c so that we
>   continuously register/unregister driver... Stats were working fine now..
> - Compile cpufreq-stats as module and insert/remove it several times after
>   removing above hack (as that doesn't let linux boot :) )..
> 
> @Nico: Can you remove the hacky code from IKS tree and test these instead to see
> if we still have any issues?

My testing of those patches took a long and winding path but finally I 
was able to do it today.

So for the 4 patches:

Tested-by: Nicolas Pitre <nico@linaro.org>
Acked-by: Nicolas Pitre <nico@linaro.org>


Nicolas

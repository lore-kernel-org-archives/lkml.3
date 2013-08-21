Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab3HUXJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:09:58 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54061 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab3HUXJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:09:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] cpufreq: create & use cpufreq_generic_init() routine
Date: Thu, 22 Aug 2013 01:20:34 +0200
Message-ID: <1493410.kWm56FEZ0a@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <cover.1377093938.git.viresh.kumar@linaro.org>
References: <cover.1377093938.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 21, 2013 08:12:19 PM Viresh Kumar wrote:
> Many CPUFreq drivers for SMP system (where all cores share same clock lines), do
> similar stuff in their ->init() part.
> 
> This patch creates a generic routine in cpufreq core which can be used by these
> so that we can remove some redundant code. And later part of patchset makes
> other drivers use this infrastructure.
> 
> Many drivers which weren't setting policy->cpus haven't been updated as they
> might have separate clocks for CPUs and setting all CPUs in policy->cpus may
> corrupt them..
> 
> This is Sixth part of my cleanup work for CPUFreq, first five are (And
> obviously its rebased over them):

OK, so the plan for merging this will be that we'll put 1 into linux-next
and add 2 to it after a few days etc. to give people a chance to test one
set of changes before going to the next one.

> 1: cpufreq: Introduce cpufreq_table_validate_and_show()
> https://lkml.org/lkml/2013/8/8/263

So perhaps we can *try* to push the above for 3.12 if it doesn't breaks
stuff left and right.

Can you please resend it with all of the ACKs collected so far?

Thanks,
Rafael


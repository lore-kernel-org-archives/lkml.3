Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab3IJL3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 07:29:34 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:61685 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3IJL3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 07:29:30 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1309091656200.6602@axis700.grange>
References: <Pine.LNX.4.64.1309091656200.6602@axis700.grange>
Date: Tue, 10 Sep 2013 16:59:29 +0530
Message-ID: <CAKohponZ+FnzqXYMbBzbun0-1iQMi2fS4syrEBC_MdF41vLCeA@mail.gmail.com>
Subject: Re: "cpufreq: fix serialization issues with freq change notifiers"
 breaks cpufreq too
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 September 2013 20:41, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> Sorry guys, I'm trying my best to stop this patch from propagating to
> stable and to get it fixed asap, so, the CC list might be a bit excessive.
> Also trying to fix the originally spare cc list, which makes it impossible
> for me to reply to the original thread, instead have to start a new one.
>
> Commit
>
> commit dceff5ce18801dddc220d6238628619c93bc3cb6
> Author: Viresh Kumar <viresh.kumar@linaro.org>
> Date:   Sun Sep 1 22:19:37 2013 +0530
>
>     cpufreq: fix serialization issues with freq change notifiers
>
> breaks .transition_ongoing counting. This leads to cpufreq-cpu0 not
> working any more. In particular switching the governor from performance to
> powersave directly after boot doesn't result in a frequency switch any
> more. Reverting this patch fixes the problem again. Tested with today's
> -next.

I have tested it again on my exynos and intel machines and couldn't see
a single problem with this patch..

I am afraid you need to give us some more information on how it broke
your stuff.. :)

And I am also not sure cpufreq-cpu0 is different then any other driver..

--
viresh

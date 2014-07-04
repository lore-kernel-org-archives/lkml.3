Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaGDEVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 00:21:42 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:51748 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaGDEVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 00:21:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140703221609.11380.6884@quantum>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
	<CAKohpomRttWnCBGEpR3cVsGYniJSnjWUnvtbg21AiYyrUnDjGw@mail.gmail.com>
	<53B4B0B3.9080000@codeaurora.org>
	<CAKohponRv6+rzJnO4cYFhXn6On1+4-KoxFSA2iU_nz130gvsug@mail.gmail.com>
	<20140703221609.11380.6884@quantum>
Date: Fri, 4 Jul 2014 09:51:39 +0530
Message-ID: <CAKohpomNv_xvcmx03pb8nj=3O33Qt-2Dj2B1q3U46mv5EBtUjA@mail.gmail.com>
Subject: Re: [PATCH 00/14] cpufreq: cpu0: Extend support beyond CPU0, V2
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>, linux-arm-msm@vger.kernel.org,
        Sachin Kamat <spk.linux@gmail.com>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Tomasz Figa <t.figa@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Rob Herring <rob.herring@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Simon Horman <horms@verge.net.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 July 2014 03:46, Mike Turquette <mturquette@linaro.org> wrote:
> Sorry for being dense, but I still do not get why trying to dynamically
> discover a shared rate-changeable clock is a better approach than simply
> describing the hardware in DT?
>
> Is adding a property to the CPU binding that describes how the CPUs in a
> cluster expect to use a clock somehow a non-starter? It is certainly a
> win for readability when staring at DT and trying to understand how DVFS
> on that CPU is meant to work (as opposed to hiding that knowledge behind
> a tree walk).

Yeah, having something like what you suggested from DT is the perfect
solution to get over this. The only reason why I am not touching that here
is to not delay other patches just because of that.

There are separate threads going on for that and probably somebody
else was trying to push for that.

That's it, nothing more. I would definitely like to use those bindings instead
 of the crazy routines we are trying here, once that is finalized :)

--
viresh

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbaGQHf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 03:35:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40645 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753461AbaGQHfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 03:35:23 -0400
Date: Thu, 17 Jul 2014 09:35:18 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
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
Subject: Re: [PATCH 00/14] cpufreq: cpu0: Extend support beyond CPU0, V2
Message-ID: <20140717093518.486ac244@free-electrons.com>
In-Reply-To: <CAKohpomPAp74Sf_DxqzFk1WzUTx5m=G-nj+d+QHW5q=gnVphhA@mail.gmail.com>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
	<CAKohpo=Z5gEHOC5q40q8dfQfoNP5-WyhjG1arV99zJiG2c+6Xg@mail.gmail.com>
	<CAKohpo=bUMKa752fBXZTb0WPYMfJtuR5uk7z-YaXYV63fhJWtg@mail.gmail.com>
	<1450785.beFNo3ByBF@vostro.rjw.lan>
	<CAKohpomPAp74Sf_DxqzFk1WzUTx5m=G-nj+d+QHW5q=gnVphhA@mail.gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Viresh Kumar,

On Thu, 17 Jul 2014 05:58:22 +0530, Viresh Kumar wrote:
> On 17 July 2014 02:48, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > I don't like that idea, but I wonder what other people think.
> 
> Hmm, the other thread around looking at the bindings is really slow.

Could you summarize what is the issue with the binding?

At least for the case where we have one clock per CPU, the DT binding
is really dead simple: each CPU node can carry a "clocks" property, and
a "clock-latency" property. I really don't see why a long discussion is
needed to agree on such a binding.

Now, if the DT binding problem is related to those cases where you have
siblings, i.e one clock controlling *some* of the CPUs, but not all
CPUs or just one CPU, then maybe we could leave this aside for now,
only support the following cases:

 * One clock for all CPUs
 * One clock for each CPU

Thanks,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

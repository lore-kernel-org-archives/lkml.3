Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934941AbaGYPl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:41:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56694 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934878AbaGYPlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:41:20 -0400
Date: Fri, 25 Jul 2014 17:41:16 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Rob Herring <rob.herring@linaro.org>,
        Mike Turquette <mturquette@linaro.org>, Nishanth Menon <nm@ti.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Sachin Kamat <spk.linux@gmail.com>
Subject: Re: [PATCH 00/14] cpufreq: cpu0: Extend support beyond CPU0, V2
Message-ID: <20140725174116.325608d2@free-electrons.com>
In-Reply-To: <CAL_JsqKqCeU0zs+rS1vxsOeh=Kuw_-gaVHtGU76Lb6TchCTytw@mail.gmail.com>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
	<20140717093518.486ac244@free-electrons.com>
	<CAKohpokZXUzXKRWBje7QF_jrvOd5dmfmWQ2Csf3xiMuvT_vPYA@mail.gmail.com>
	<2399813.Puj1SZWhCh@vostro.rjw.lan>
	<CAKohpomKzK8pMJs1gv+uXxhd17HtCQyfjSnVYw9KpGz6FwbgDA@mail.gmail.com>
	<CAKohpo=HKUkGRK4NX7E59z5QthcKbZKETB-DuP10xj3x+vdHaQ@mail.gmail.com>
	<CAL_JsqKqCeU0zs+rS1vxsOeh=Kuw_-gaVHtGU76Lb6TchCTytw@mail.gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, 25 Jul 2014 09:29:09 -0500, Rob Herring wrote:

> > Any idea on how can we get some temporary solution for 3.17 as we didn't
> > conclude anything yet on bindings ?
> 
> A temporary solution would have to be NOT in DT because once you add
> something into DT you are stuck with it for some time. You could
> simply support independent clocks by looking at the platform type, but
> that is still risky since you may want to define the OPP in DT
> differently for the 2 cases.
> 
> The other problem with temporary solutions is once they are accepted,
> people loose motivation to create the permanent solution. "Can you
> take this now and I'll fix the issues later" is a red flag to
> maintainers.

On the Marvell Armada XP side of things, the OPPs are registered
dynamically because they change from one board to the other. The only
thing that is in the DT for cpufreq-generic is the clock-latency
parameter.

Thanks,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

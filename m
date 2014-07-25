Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760557AbaGYOeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:34:20 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:36120 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbaGYOeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:34:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKqCeU0zs+rS1vxsOeh=Kuw_-gaVHtGU76Lb6TchCTytw@mail.gmail.com>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
	<20140717093518.486ac244@free-electrons.com>
	<CAKohpokZXUzXKRWBje7QF_jrvOd5dmfmWQ2Csf3xiMuvT_vPYA@mail.gmail.com>
	<2399813.Puj1SZWhCh@vostro.rjw.lan>
	<CAKohpomKzK8pMJs1gv+uXxhd17HtCQyfjSnVYw9KpGz6FwbgDA@mail.gmail.com>
	<CAKohpo=HKUkGRK4NX7E59z5QthcKbZKETB-DuP10xj3x+vdHaQ@mail.gmail.com>
	<CAL_JsqKqCeU0zs+rS1vxsOeh=Kuw_-gaVHtGU76Lb6TchCTytw@mail.gmail.com>
Date: Fri, 25 Jul 2014 20:04:17 +0530
Message-ID: <CAKohpomDGc9Y8yn0SuT9PYRQqx+0Ln10g9V-ZXd=itgXpGqP6g@mail.gmail.com>
Subject: Re: [PATCH 00/14] cpufreq: cpu0: Extend support beyond CPU0, V2
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Rob Herring <rob.herring@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Nishanth Menon <nm@ti.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 July 2014 19:59, Rob Herring <robherring2@gmail.com> wrote:
> A temporary solution would have to be NOT in DT because once you add
> something into DT you are stuck with it for some time. You could

I agree..

> simply support independent clocks by looking at the platform type, but
> that is still risky since you may want to define the OPP in DT
> differently for the 2 cases.

Or because we are going to create platform devices for now, lets have
some platform data for cpufreq-cpu0 ?

> The other problem with temporary solutions is once they are accepted,
> people loose motivation to create the permanent solution. "Can you
> take this now and I'll fix the issues later" is a red flag to
> maintainers.

I completely agree, but there are few points here which might make the red
flag yellow if not green :)
- I co-maintain this framework and so I do care about it :)
- Even with the temporary stuff the solution wouldn't be complete for platforms
with multiple clusters having separate clock lines.

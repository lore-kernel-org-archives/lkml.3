Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbaGXKsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:48:10 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:47062 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757734AbaGXKsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 06:48:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpomKzK8pMJs1gv+uXxhd17HtCQyfjSnVYw9KpGz6FwbgDA@mail.gmail.com>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
	<20140717093518.486ac244@free-electrons.com>
	<CAKohpokZXUzXKRWBje7QF_jrvOd5dmfmWQ2Csf3xiMuvT_vPYA@mail.gmail.com>
	<2399813.Puj1SZWhCh@vostro.rjw.lan>
	<CAKohpomKzK8pMJs1gv+uXxhd17HtCQyfjSnVYw9KpGz6FwbgDA@mail.gmail.com>
Date: Thu, 24 Jul 2014 16:18:05 +0530
Message-ID: <CAKohpo=HKUkGRK4NX7E59z5QthcKbZKETB-DuP10xj3x+vdHaQ@mail.gmail.com>
Subject: Re: [PATCH 00/14] cpufreq: cpu0: Extend support beyond CPU0, V2
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Rob Herring <rob.herring@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Nishanth Menon <nm@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Simon Horman <horms@verge.net.au>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Sachin Kamat <spk.linux@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 July 2014 09:47, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> Before I apply anything in this area, I need a clear statement from the ARM
>> people as a group on what the approach is going to be.

@Rafael: The only patch which has blocked this set is:

cpufreq: cpu0: Extend support beyond CPU0

This is about finding which CPUs share clock line..

Other patches are sort of independent of this one and cpufreq-cpu0 would
continue to work for existing platforms if we apply these patches.

I was wondering if you would like to apply other patches leaving this one?
I will then rebase stuff again and send non-controversial patches for 3.17.
So, that we get something in 3.17 and the last change can be merged during
rc's as well once we finalize on bindings..

> Mike/Rob/Stephen: I believe Atleast three of you should express your views
> now :)

Any idea on how can we get some temporary solution for 3.17 as we didn't
conclude anything yet on bindings ?

--
viresh

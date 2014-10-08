Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaJHITo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:19:44 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:45551 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaJHITk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:19:40 -0400
MIME-Version: 1.0
In-Reply-To: <20141008101115.1835927a@free-electrons.com>
References: <CAKohpo=7q9bDcHRxLehNLX6A2idGxUy3jEWvQ+EGbKOQG-MH2g@mail.gmail.com>
	<1412754534-14068-1-git-send-email-mturquette@linaro.org>
	<CAKohpo=9XG7XiLxBf=yo7=QCruawYxqPctC6kqB+syERFCoT6Q@mail.gmail.com>
	<20141008101115.1835927a@free-electrons.com>
Date: Wed, 8 Oct 2014 13:49:40 +0530
Message-ID: <CAKohpo=7VxrgdK9zPP89Px3aTiGhFihJ3uetC680fONDgE6O8Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] allow cpufreq drivers to export flags
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Sachin Kamat <spk.linux@gmail.com>,
        "pramod.gurav@smartplayin.com" <pramod.gurav@smartplayin.com>,
        Rob Herring <rob.herring@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Lior Amsalem <alior@marvell.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 October 2014 13:41, Thomas Petazzoni
<thomas.petazzoni@free-electrons.com> wrote:
> On Wed, 8 Oct 2014 13:24:30 +0530, Viresh Kumar wrote:
>> On 8 October 2014 13:18, Mike Turquette <mturquette@linaro.org> wrote:

>> > This series is partially in response to a discussion around DT bindings
>> > for CPUfreq drivers [0], but it is also needed for on-going work to
>> > integrate CPUfreq with the scheduler. In particular a scheduler-driven

> Well, when one has to merge a large number of changes, we often
> recommend to merge them piece by piece, which is what Mike is trying to
> do here. So we cannot at the same time ask developers to merge things
> in small pieces that are easy to review and to merge everything
> together because the users of a given API are not there yet.

>From the wording of Mike it looks like:
- This is required by cpufreq drivers - today
- And this will also be useful for scheduler

The first point doesn't stand true anymore. Lets wait for Mike's reply and
see his opinion.

And then the patches are so small and there are no objections against
them. I don't think getting them with the scheduler changes is that bad
of an idea. In worst case, what if he has to redesign his idea? The new
routines will stay without a caller then :)

--
viresh

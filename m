Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbaGIPU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:20:56 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:63310 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960AbaGIPUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:20:53 -0400
MIME-Version: 1.0
In-Reply-To: <53BD53EA.8050708@ti.com>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
	<5f7164d789e87c62d722b575980c92dfd0504334.1404231535.git.viresh.kumar@linaro.org>
	<53BD53EA.8050708@ti.com>
Date: Wed, 9 Jul 2014 20:50:53 +0530
Message-ID: <CAKohponitwHj40xx_TWjhgVxdqOZ5_dpOB_3avTs=+vo4Ng-gA@mail.gmail.com>
Subject: Re: [PATCH 02/14] clk: Create of_clk_shared_by_cpus()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Shawn Guo <shawn.guo@linaro.org>,
        Nishanth Menon <nm@ti.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Sachin Kamat <spk.linux@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 July 2014 20:08, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
> I might be wrong but this API seems to bit short cited. We should probably
> handle it bit better since there are more cases instead of just checking CPU
> tuple. More than two CPUs may share the clock so discovering that in one iteration
> is better. I also think this is closely related to CPU topology.
>
> - CPUs part of 'a cluster' shares same clock.
> - Multiple clusters may share same clock
> - Every CPU might be clocked from separate PLL.

All these configurations are currently supported by this series.

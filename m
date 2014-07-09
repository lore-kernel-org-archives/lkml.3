Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbaGIPRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:17:19 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:52208 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834AbaGIPRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:17:15 -0400
MIME-Version: 1.0
In-Reply-To: <53BD576F.2010408@ti.com>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
	<b26946cc4573904cd1ef0212ad053a983b547c23.1404231535.git.viresh.kumar@linaro.org>
	<53BD576F.2010408@ti.com>
Date: Wed, 9 Jul 2014 20:47:14 +0530
Message-ID: <CAKohpokz4eyw86Uxp_aA=9T9x-X=kTV=_=zx4dEuC2ZyR=3pKw@mail.gmail.com>
Subject: Re: [PATCH 09/14] cpufreq: cpu0: Move per-cluster initialization code
 to ->init()
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

On 9 July 2014 20:23, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
> I scanned this patch and subsequent patches from the series. Since you are
> modifying the interfaces and bindings, I just think its better if we can
> address the cases where separate clock lines will be used by CPUs.
>
> Surely don't want to increase your work neither want hold the progress
> of the series but if you look at the changes to the interfaces, they
> give you a feeling of incompleteness.

Lets talk in the other thread you raised, 2/14 ..

>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
> Would you able to give some idea about what will it take to address that one
> remainder case as well as part of this series.

Which one? This:

> We still *don't* support platforms with separate clock/voltage lines for CPUs.
> This would be done in a separate patch.

Its already fixed as part of this series.

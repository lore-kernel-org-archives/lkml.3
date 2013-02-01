Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab3BAICu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 03:02:50 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:54069 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab3BAICr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 03:02:47 -0500
MIME-Version: 1.0
In-Reply-To: <510B6FC5.8030309@ti.com>
References: <1bf82454ab1f16b13212548d7c9605067c8b7a0d.1359700705.git.viresh.kumar@linaro.org>
	<902bed453159832925df76e24806f3b919fdfc74.1359700706.git.viresh.kumar@linaro.org>
	<510B6510.6060608@ti.com>
	<CAKohponEsSrwLWbi4WJ19i8XkzEiL0De2ShLePBdygunmGEo5g@mail.gmail.com>
	<510B6FC5.8030309@ti.com>
Date: Fri, 1 Feb 2013 13:32:47 +0530
Message-ID: <CAKohpomxi91kXR+th2BbruKigmLPmrDQf1s_Mf11C3Bs53aB3A@mail.gmail.com>
Subject: Re: [PATCH 3/3] cpufreq: Remove unnecessary use of policy->shared_type
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linaro-dev@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org, rjw@sisk.pl,
        Steve.Bannister@arm.com, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 February 2013 13:03, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
> I am not talking about just notifiers. This is for external users who
> has subscribed for notifiers. The point is whether the core CPUFReq
> gets updated without that flag for all affected CPU.

Yes, its safe. Follow this thread, yesterday i explained this to Tomasz Figa:

http://www.spinics.net/lists/arm-kernel/msg221629.html

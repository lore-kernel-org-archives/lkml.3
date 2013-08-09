Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967712Ab3HIDTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 23:19:21 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:62650 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967580Ab3HIDTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 23:19:19 -0400
MIME-Version: 1.0
In-Reply-To: <5203E874.7070907@wwwdotorg.org>
References: <cover.1375886595.git.viresh.kumar@linaro.org>
	<8d192a13cb7e088943da40689d62bc6353bd8604.1375886595.git.viresh.kumar@linaro.org>
	<52028620.6000608@wwwdotorg.org>
	<CAKohpokVgcMfmKmjkxc9Dr3z6mBKad23uUdB4ydN_xzGHdfedQ@mail.gmail.com>
	<52028859.20008@wwwdotorg.org>
	<CAKohpokK7F7tYJnisVjF=NCRb9zUjQNzrFdXs+QsPSb4oqyytA@mail.gmail.com>
	<52029713.5070808@wwwdotorg.org>
	<CAKohpoky9-E2XoxAQy_oQ3sMxvAv5ZfBdDQPd6zUxcSwyKmzXg@mail.gmail.com>
	<5203E874.7070907@wwwdotorg.org>
Date: Fri, 9 Aug 2013 08:49:18 +0530
Message-ID: <CAKohpomaCVLdJoMDhTcRkELvkE6UrtFjN4W7STf=MgYR8sxj4Q@mail.gmail.com>
Subject: Re: [PATCH 1/6] clk: Tegra: Add CPU0 clock driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: mturquette@linaro.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Nishanth Menon <nm@ti.com>
Cc: swarren@nvidia.com, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 August 2013 00:20, Stephen Warren <swarren@wwwdotorg.org> wrote:
> I don't think so. I think it's reasonable to have a per-SoC cpufreq
> driver whose primary content is the parameterization data and/or custom
> hooks for a unified core cpufreq driver. The duplicate parts of each
> cpufreq driver can be moved into the core cpufreq driver, but the
> non-duplicate parts remain. That's how many other subsystems work (MMC,
> USB, ASoC spring to mind).

Guys in the --to list:

Please shout before its too late...

I can understand why Stephen is asking not to implement a virtual clock
driver for cpu as there is no clock corresponding to that.. We are just playing
with existing clocks there..

But I thought these clock APIs can be considered as hooks that we were
looking for and so shouldn't be a problem..

But yes, different people see things differently..

So, if I take Stephen's suggestions then I need to implement hooks into
cpufreq-cpu0 driver for taking freq-table/ setting clk rates, etc...

Let me know if anybody has a issue with that before we actually implement
that..

--
viresh

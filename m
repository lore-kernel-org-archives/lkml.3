Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbaGJNgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:36:47 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:64904 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaGJNgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:36:45 -0400
MIME-Version: 1.0
In-Reply-To: <53BE95B2.50606@ti.com>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
	<1ba7771e910084cd0820c19ca5994fe1b3d6451d.1404231535.git.viresh.kumar@linaro.org>
	<53BD5564.2060704@ti.com>
	<CAKohpo=KUktq8XJv7Ayis1Q3ik+Wh3wb8wN6VpRAtOsbbv9XCw@mail.gmail.com>
	<CAGo_u6rBMGO9t87w1e4KCTA+ckF8aeFr+jMw00fks-=y+9JGdA@mail.gmail.com>
	<53BE95B2.50606@ti.com>
Date: Thu, 10 Jul 2014 19:06:44 +0530
Message-ID: <CAKohpommhNQ-Hme8R9CsXisMD4CZ1cTLwnFNPKFRWi02apKZnw@mail.gmail.com>
Subject: Re: [PATCH 07/14] cpufreq: cpu0: OPPs can be populated at runtime
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Shawn Guo <shawn.guo@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Sachin Kamat <spk.linux@gmail.com>, Dave Gerlach <d-gerlach@ti.com>,
        linux-omap <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 July 2014 19:01, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
> Yep. Last time I blocked the series because all the DT conversions
> were not done. Considering now the cpufreq-generic can work on non
> DT platforms, I am ok to remove the omap-cpufreq.

Great.

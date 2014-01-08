Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbaAGX7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 18:59:55 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59615 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754293AbaAGX7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:59:45 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 Resend] cpufreq: create cpufreq_generic_get() routine
Date: Wed, 08 Jan 2014 01:13:33 +0100
Message-ID: <2696764.XiYMgf5S93@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <d9239e0a5df99392647ff8343673342f89d09476.1389059568.git.viresh.kumar@linaro.org>
References: <d9239e0a5df99392647ff8343673342f89d09476.1389059568.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 07, 2014 07:24:32 AM Viresh Kumar wrote:
> CPUFreq drivers that use clock frameworks interface,i.e. clk_get_rate(), to get
> CPUs clk rate, has similar sort of code used for most of them.
> 
> This patch adds a generic ->get() which will do the same thing for them. All
> those drivers are required to now is to set .get to cpufreq_generic_get() and
> set their clk pointer in policy->clk during ->init().
> 
> Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> Acked-by: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> Rafael,
> 
> V2->V3: As asked by you earlier, I have merged all 23 patches here as they had
> common log and were touching separate drivers. This is already acked by many
> people.  Please see if looks okay for 3.14.

Applied to bleeding-edge, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

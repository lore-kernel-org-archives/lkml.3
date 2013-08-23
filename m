Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab3HWTaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:30:01 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57745 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748Ab3HWT37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:29:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] cpufreq: create & use cpufreq_generic_get() routine
Date: Fri, 23 Aug 2013 21:40:38 +0200
Message-ID: <2330969.4ermKsDahJ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <cover.1377272740.git.viresh.kumar@linaro.org>
References: <cover.1377272740.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 23, 2013 09:20:35 PM Viresh Kumar wrote:
> CPUFreq drivers that use clock frameworks interface,i.e. clk_get_rate(), to get
> CPUs clk rate, has similar sort of code used for most of them.
> 
> This patchset adds a generic ->get() which will do the same thing for them. All
> those drivers are required to now is to set .get to cpufreq_generic_get() and
> set their clk pointer in policy->clk during ->init().
> 
> Later part of this patchset fixes 17 drivers with this change.
> 
> That's part 7 of my generic cleanups for CPUFreq core, first six are here:

And that's the last one for 3.13, right?

Rafael


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248AbaF3Eub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 00:50:31 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:48948 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaF3Eu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 00:50:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140628145253.GB7869@dragon>
References: <cover.1403684824.git.viresh.kumar@linaro.org>
	<e9c0eef07745e561b9d12dcb50c3e2f7eb3e8880.1403684824.git.viresh.kumar@linaro.org>
	<20140628145253.GB7869@dragon>
Date: Mon, 30 Jun 2014 10:20:29 +0530
Message-ID: <CAKohpomX0Wk_aL117ZqXsC-jruHi8wOj=A4YqtNDcStJZ8iJOw@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: cpu0: Extend support beyond CPU0
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org, Sachin Kamat <spk.linux@gmail.com>,
        Thomas P Abraham <thomas.ab@samsung.com>, Nishanth Menon <nm@ti.com>,
        Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 June 2014 20:22, Shawn Guo <shawn.guo@linaro.org> wrote:
> Thanks for all the effort on maintaining and improving cpufreq-cpu0
> driver.

You're welcome..

> Your patch rewrote the most part of the driver, so I'd like to
> hand over the driver to you.  Please add yourself as the primary person
> for MODULE_AUTHOR.

I don't think a complete handover would be right, and so still keeping
you as author :)

Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Mon Jun 30 10:15:22 2014 +0530

    cpufreq: cpu0: Add Module Author

    Two people are maintaining it now, Viresh and Shawn. Add Viresh's details in
    MODULE_AUTHOR() and copyright section.

    Suggested-by: Shawn Guo <shawn.guo@linaro.org>
    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq-generic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/cpufreq/cpufreq-generic.c
b/drivers/cpufreq/cpufreq-generic.c
index 4da3f2f..5656dd1 100644
--- a/drivers/cpufreq/cpufreq-generic.c
+++ b/drivers/cpufreq/cpufreq-generic.c
@@ -1,6 +1,9 @@
 /*
  * Copyright (C) 2012 Freescale Semiconductor, Inc.
  *
+ * Copyright (C) 2014 Linaro.
+ * Viresh Kumar <viresh.kumar@linaro.org>
+ *
  * The OPP code in function set_target() is reused from
  * drivers/cpufreq/omap-cpufreq.c
  *
@@ -402,6 +405,7 @@ static struct platform_driver generic_cpufreq_platdrv = {
 };
 module_platform_driver(generic_cpufreq_platdrv);

+MODULE_AUTHOR("Viresh Kumar <viresh.kumar@linaro.org>");
 MODULE_AUTHOR("Shawn Guo <shawn.guo@linaro.org>");
 MODULE_DESCRIPTION("Generic cpufreq driver");
 MODULE_LICENSE("GPL");

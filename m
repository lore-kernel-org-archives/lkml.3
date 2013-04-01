Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692Ab3DAVW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 17:22:56 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:62890 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab3DAVWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 17:22:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokkyQK+650aPLtdXJ0wHWupR=-bcTM_eCoZRDy3N47HJQ@mail.gmail.com>
References: <cover.1364229828.git.viresh.kumar@linaro.org>
	<afc636963b63becccf34d092203c53369bd1b735.1364229828.git.viresh.kumar@linaro.org>
	<CAKohponax2iDZeA-WG_L2XVHU5GGJB2nSPWVoVxbZUoez1ZpDw@mail.gmail.com>
	<CAKohpokkyQK+650aPLtdXJ0wHWupR=-bcTM_eCoZRDy3N47HJQ@mail.gmail.com>
Date: Mon, 1 Apr 2013 14:22:53 -0700
Message-ID: <CA+8MBbLwxiPPvyKyQNEDSbNKthpAmooKVe7b+pg-NCETOkSLPA@mail.gmail.com>
Subject: Re: [PATCH 4/9] ia64: cpufreq: move cpufreq driver to drivers/cpufreq
From: Tony Luck <tony.luck@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        arvind.chauhan@arm.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, cpufreq@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-kernel@lists.linaro.org, arnd.bergmann@linaro.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Repost in plain text so the lists don't bounce it - curse you Gmail
for switching to HTML]

> Any comments on this patch?

This part looks OK ... But is there a big finish later in the patch series where
you unify some/all of the cpufreq code across architectures?  By
itself just moving
bits from arch/ia64/kernel/cpufreq to drivers/cpufreq/ doesn't look to add
much value.

-Tony

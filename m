Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670Ab3DBAtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 20:49:39 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:50904 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848Ab3DBAtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 20:49:36 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBbLwxiPPvyKyQNEDSbNKthpAmooKVe7b+pg-NCETOkSLPA@mail.gmail.com>
References: <cover.1364229828.git.viresh.kumar@linaro.org>
	<afc636963b63becccf34d092203c53369bd1b735.1364229828.git.viresh.kumar@linaro.org>
	<CAKohponax2iDZeA-WG_L2XVHU5GGJB2nSPWVoVxbZUoez1ZpDw@mail.gmail.com>
	<CAKohpokkyQK+650aPLtdXJ0wHWupR=-bcTM_eCoZRDy3N47HJQ@mail.gmail.com>
	<CA+8MBbLwxiPPvyKyQNEDSbNKthpAmooKVe7b+pg-NCETOkSLPA@mail.gmail.com>
Date: Tue, 2 Apr 2013 06:19:35 +0530
Message-ID: <CAKohpompxOpwi7fsy1m5UBxymR=dsVra3wvMcvziu7jd9iq8Ow@mail.gmail.com>
Subject: Re: [PATCH 4/9] ia64: cpufreq: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tony Luck <tony.luck@gmail.com>
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

On 2 April 2013 02:52, Tony Luck <tony.luck@gmail.com> wrote:
> [Repost in plain text so the lists don't bounce it - curse you Gmail
> for switching to HTML]

Just to let others know how you fixed it: Above the compose area there
is a small button (or whatever you call it) which can show "Rich Formatting"
or "plain text". Click on that so that it shows "Rich Formatting" all the time.

>> Any comments on this patch?
>
> This part looks OK ... But is there a big finish later in the patch series where
> you unify some/all of the cpufreq code across architectures?  By
> itself just moving
> bits from arch/ia64/kernel/cpufreq to drivers/cpufreq/ doesn't look to add
> much value.

There are people (including me) who tried various times to get things fixed/
consolidated in cpufreq area. They mostly worked over cleaning up stuff inside
drivers/cpufreq area rather then looking at complete kernel. To make that
path easy, this patchset is the first step: "Bring all of them together"..

After this more consolidation work may follow which will span all
cpufreq drivers.
One aspect would be to use cpufreq-cpu0 for whatever platform we can.

For now, your Ack will work :)

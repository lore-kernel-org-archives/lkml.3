Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaFYIrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:47:46 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:45348 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaFYIrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:47:42 -0400
MIME-Version: 1.0
In-Reply-To: <1403654783-7176-11-git-send-email-sboyd@codeaurora.org>
References: <1403654783-7176-1-git-send-email-sboyd@codeaurora.org>
	<1403654783-7176-11-git-send-email-sboyd@codeaurora.org>
Date: Wed, 25 Jun 2014 14:17:41 +0530
X-Google-Sender-Auth: ZW6zrltUUliu7cEPRbmyZfu7Uas
Message-ID: <CAOh2x=ktLkZYF-xAUKCNAhUuLAED76EpnYx2B2SwiottwAxBUA@mail.gmail.com>
Subject: Re: [RFC/PATCH 10/12] cpufreq: Add a cpufreq-krait based on cpufreq-cpu0
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 5:36 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> Krait processors have individual clocks for each CPU that can
> scale independently from one another. cpufreq-cpu0 is fairly
> close to this, but assumes that there is only one clock for all
> CPUs. Add a driver to support the Krait configuration.

You missed both cpufreq maintainers and PM-list in cc :(

> TODO: Merge into cpufreq-cpu0? Or make generic?

Haven't gone into minute details of this driver but have tried
what looks to be the way ahead.

As you also mentioned merging with cpufreq-cpu0 might be
worth and I have tried extending cpufreq-cpu0's support
for all CPUs..

It should work for Krait. I have tested it for Exynos dual-A15
and it didn't explode :)

Links aren't available yet but you can find that in your
mailbox with this subject:

[PATCH 0/2] cpufreq: cpu0: Extend support beyond CPU0

Cc'd everybody from this thread..

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab3H1Ffz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:35:55 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:61191 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab3H1Ffx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:35:53 -0400
MIME-Version: 1.0
In-Reply-To: <521BA068.8030003@semaphore.gr>
References: <521BA068.8030003@semaphore.gr>
Date: Wed, 28 Aug 2013 11:05:52 +0530
Message-ID: <CAKohpon9mokWAg-cfyKtSKRTu2vyQ9oKnM6XYD+sAzmzXoU9fg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: governors: Remove duplicate check of target freq
 in supported range
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 August 2013 00:07, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> Function __cpufreq_driver_target checks if target_freq is within
> policy->min and policy->max range. generic_powersave_bias_target also
> checks if target_freq is valid through cpufreq_frequency_table_target
> call. So, drop the unnecessary duplicate check in *_check_cpu functions.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/cpufreq_conservative.c | 4 ----
>  drivers/cpufreq/cpufreq_ondemand.c     | 3 ---
>  2 files changed, 7 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

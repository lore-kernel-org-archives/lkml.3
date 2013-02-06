Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab3BFFgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 00:36:21 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:54564 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3BFFgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 00:36:19 -0500
MIME-Version: 1.0
In-Reply-To: <511173DF.8060308@semaphore.gr>
References: <511173DF.8060308@semaphore.gr>
Date: Wed, 6 Feb 2013 11:05:45 +0530
X-Google-Sender-Auth: li4KSE-CTGW6w_1bZaD7atKjrGM
Message-ID: <CAOh2x=ksAibntsfGm51r+JiQOAhHYYmHF1o=_H97fSKqGcq_mQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: ondemand: Replace down_differential tuner with adj_up_threshold
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 2:34 AM, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> In order to avoid the calculation of up_threshold - down_differential
> every time that the frequency must be decreased, we replace the
> down_differential tuner with the adj_up_threshold which keeps the
> difference across multiple checks.
>
> Update the adj_up_threshold only when the up_theshold is also updated.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/cpufreq_governor.h |  2 +-
>  drivers/cpufreq/cpufreq_ondemand.c | 16 ++++++++++------
>  2 files changed, 11 insertions(+), 7 deletions(-)

Makes sense.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

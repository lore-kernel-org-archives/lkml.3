Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab3HGLWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:22:36 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:41129 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400Ab3HGLWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:22:35 -0400
MIME-Version: 1.0
In-Reply-To: <1375874171-16951-1-git-send-email-amit.daniel@samsung.com>
References: <1375874171-16951-1-git-send-email-amit.daniel@samsung.com>
Date: Wed, 7 Aug 2013 16:52:34 +0530
Message-ID: <CAKohpokp04HXau1fOA6w9K675LwRw6uCCZZKyFAJtF1_pkcC=Q@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: exynos5440: Fix to skip when new frequency same
 as current
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 August 2013 16:46, Amit Daniel Kachhap <amit.daniel@samsung.com> wrote:
> This patch fixes the issue of un-necessary setting the clock controller
> when the new target frequency is same as the current one. This case usually
> occurs with governors like ondemand which passes the target frequency as the
> percentage of average frequency. This check is present in most of the cpufreq
> driver.
>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  drivers/cpufreq/exynos5440-cpufreq.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)

Applied.

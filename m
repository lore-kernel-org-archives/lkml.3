Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab3C1IeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 04:34:03 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:47500 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab3C1Id6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:33:58 -0400
MIME-Version: 1.0
In-Reply-To: <1364457923-8499-1-git-send-email-amit.daniel@samsung.com>
References: <1364457923-8499-1-git-send-email-amit.daniel@samsung.com>
Date: Thu, 28 Mar 2013 14:03:58 +0530
Message-ID: <CAKohponyHMWB6f=5uMcyyR7ym-B6KKR9J_AavsYaHTDvMWPV9w@mail.gmail.com>
Subject: Re: [PATCH V5 0/4] cpufreq: exynos5440: support for cpufreq driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>, cpufreq@vger.kernel.org,
        Inderpal Singh <inderpal.singh@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 March 2013 13:35, Amit Daniel Kachhap <amit.daniel@samsung.com> wrote:
> Submitting the V5 version of exynos5440 cpufreq driver. This patchset addresses
> all the coding and design concerns raised especially by Viresh.
>
> Changes in V5:
> * Removed the unnecessary DT look up entry from mach-exynos5-dt.c.
> * Fixed all coding and comments issue raised by Viresh.

People normally forget what they commented on earlier and that's why
this change log phenomenon was introduced. Some more details would
be better here for next time.

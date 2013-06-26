Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab3FZLFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:05:37 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45481 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab3FZLFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:05:33 -0400
MIME-Version: 1.0
In-Reply-To: <1370941408-29304-4-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1370941408-29304-1-git-send-email-l.majewski@samsung.com>
	<1370941408-29304-4-git-send-email-l.majewski@samsung.com>
Date: Wed, 26 Jun 2013 16:35:32 +0530
Message-ID: <CAKohponJ5FyuKywCGz5j8GYomwqEJ0B-CvJybp+_eLjrsRkXDA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] cpufreq:exynos:Extend Exynos cpufreq driver to
 support boost framework
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 June 2013 14:33, Lukasz Majewski <l.majewski@samsung.com> wrote:
> The struct cpufreq_driver has been extended to embrace the information
> related to boost support.
>
> When "boost_mode" device tree attribute is defined for a platform, the
> low_level_boost pointer is filled with proper address. The
> .low_level_boost field filled to NULL, indicates that boost is not
> supported.

This patch is still few generations back :)

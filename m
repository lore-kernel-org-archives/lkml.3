Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408Ab3BGNWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:22:24 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:59067 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab3BGNWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:22:21 -0500
MIME-Version: 1.0
In-Reply-To: <2158181.aoVXdpLJe2@vostro.rjw.lan>
References: <cover.1360232293.git.viresh.kumar@linaro.org>
	<2158181.aoVXdpLJe2@vostro.rjw.lan>
Date: Thu, 7 Feb 2013 18:52:20 +0530
Message-ID: <CAKohponLrVG+ubf5Ok+7AvoWKRF16YLqUEWAU6hH7-H_R=r0Ow@mail.gmail.com>
Subject: Re: [PATCH 0/4] CPUFreq Fixes for 3.9
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: valdis.kletnieks@vt.edu, artem.savkov@gmail.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com, dirk.brandewie@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 February 2013 18:35, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> I think they all make sense, so applied to linux-next.
>
> I would prefer not to make any more changes to cpufreq before v3.9 from now on,
> except for fixes and maybe the Drik's patchset that I kind of scheduled for

Dirk :)

> merging into bleeding-edge later today.

I probably have few more for you. Some sparse warnings to be fixed for
Dirks work and an dangling exynos patch which is waiting for your reply :)

--
viresh

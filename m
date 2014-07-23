Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644AbaGWQuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:50:18 -0400
Received: from mail-oi0-f54.google.com ([209.85.218.54]:33959 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757886AbaGWQuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:50:15 -0400
MIME-Version: 1.0
In-Reply-To: <53CFA33F.6030307@nvidia.com>
References: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com>
	<1405957142-19416-15-git-send-email-ttynkkynen@nvidia.com>
	<CAKohpomQthJ_XE-HhzW07Q4aVtxQVy97iaL0Vy6Q4Lhw22A=VA@mail.gmail.com>
	<53CFA33F.6030307@nvidia.com>
Date: Wed, 23 Jul 2014 22:20:14 +0530
Message-ID: <CAKohponLh66Ubr6=wY2OZCCrK11KZDj=DmXXqXsGGTHSG45wpA@mail.gmail.com>
Subject: Re: [PATCH v2 14/16] cpufreq: Add cpufreq driver for Tegra124
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 July 2014 17:27, Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:
> The platform device is required for the deferred probe that can happen if the
> DFLL driver hasn't initialized yet, and module_init() callbacks don't seem to
> respect -EPROBE_DEFER.

Oh, which call in this file will return EPROBE_DEFER? I couldn't make out
which one will depend on DFLL driver.

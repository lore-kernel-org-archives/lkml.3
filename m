Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaGKJOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:14:10 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:36047 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaGKJOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:14:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140711091207.GY23218@tbergstrom-lnx.Nvidia.com>
References: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com>
	<1405028569-14253-13-git-send-email-ttynkkynen@nvidia.com>
	<CAKohpom9ORXFiUU4=V+CxgN0ZOFLMEhEjHiU8HsYUYDybNXgHQ@mail.gmail.com>
	<20140711091207.GY23218@tbergstrom-lnx.Nvidia.com>
Date: Fri, 11 Jul 2014 14:44:07 +0530
Message-ID: <CAKohpokGOtdY2SyJuN1QcVoDy2wsMcveiyr1e4cr0oe2j__h5g@mail.gmail.com>
Subject: Re: [PATCH 12/13] cpufreq: Add cpufreq driver for Tegra124
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 July 2014 14:42, Peter De Schrijver <pdeschrijver@nvidia.com> wrote:
> I don't think that's going to work? The voltage scaling is handled in hw.

Ahh..

> cpufreq-cpu0 seems to assume explicit sw control of the vdd_cpu regulator?

Its optional. If it fails to find a regulator, it doesn't depend or
play with it.

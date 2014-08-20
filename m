Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaHTGjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:39:03 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:37377 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaHTGjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:39:01 -0400
MIME-Version: 1.0
In-Reply-To: <53F3A900.8010805@nvidia.com>
References: <1408419205-10048-1-git-send-email-tuomas.tynkkynen@iki.fi>
	<1408419205-10048-14-git-send-email-tuomas.tynkkynen@iki.fi>
	<CAKohpokQOALPH13Ykz4nTBOby8J1X6_F30LNKz=gsC4wN3=3vg@mail.gmail.com>
	<53F3A900.8010805@nvidia.com>
Date: Wed, 20 Aug 2014 12:09:00 +0530
Message-ID: <CAKohponcZv9-MFNUQFxC_49-+P6QOhdjxsnYAyL3i4sXdCBYrw@mail.gmail.com>
Subject: Re: [PATCH v3 13/15] cpufreq: Add cpufreq driver for Tegra124
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
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
        Paul Walmsley <pwalmsley@nvidia.com>, Vince Hsu <vinceh@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 August 2014 01:14, Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:
> There's actually a (mis-?)feature in git format-patch: a literal '---'
> line in a commit message won't be escaped, so the patch notes can be
> written in the commit message directly so the patch files don't need
> to be modified by hand.

How exactly? Can you list the command here please..

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3ILKav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:30:51 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:33358 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab3ILKat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:30:49 -0400
MIME-Version: 1.0
In-Reply-To: <2753290.JbKAdhJjui@vostro.rjw.lan>
References: <20130911201239.7832.72612.stgit@srivatsabhat.in.ibm.com>
	<CAKohpomsHSMWmGAACurpN1dYSsvHvH6w_SDpQ5c7CE_1R2MGMg@mail.gmail.com>
	<5231695D.5070404@linux.vnet.ibm.com>
	<2753290.JbKAdhJjui@vostro.rjw.lan>
Date: Thu, 12 Sep 2013 16:00:48 +0530
Message-ID: <CAKohpo=et2H-4fvy0psNVen-hs4A9sLz2y4ojAnmQBPKq6ew0g@mail.gmail.com>
Subject: Re: [PATCH 3/3] cpufreq: Prevent problems in update_policy_cpu() if
 last_cpu == new_cpu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2013 16:10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Can you please prepare a patch against Documentation/SubmittingPatches with the
> above paragraph in it?  Seriously.

+1

> There are people who don't really see a reason for writing good patch
> changelogs.

+1 for being one of those people :)

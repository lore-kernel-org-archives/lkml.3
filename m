Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbaKUJRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:17:36 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:58771 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbaKUJRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:17:34 -0500
MIME-Version: 1.0
In-Reply-To: <dedc11e3150d44ee89bb1e96b5447687@DM2PR03MB574.namprd03.prod.outlook.com>
References: <1416554882-16566-1-git-send-email-Yuantian.Tang@freescale.com>
	<1416554882-16566-2-git-send-email-Yuantian.Tang@freescale.com>
	<CAKohpo=xLOxXrCJNO0LmrVxMDNsFy2Kxg6bNzHm=vQCJnBvSaw@mail.gmail.com>
	<dedc11e3150d44ee89bb1e96b5447687@DM2PR03MB574.namprd03.prod.outlook.com>
Date: Fri, 21 Nov 2014 14:47:33 +0530
Message-ID: <CAKohpomtSBosPqU_DcB2Y=gxLXCG9d7MSy92LsMjeebQmVwDxg@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: qoriq: rename the driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Yuantian Tang <Yuantian.Tang@freescale.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 November 2014 14:46, Yuantian Tang <Yuantian.Tang@freescale.com> wrote:
> When I use -C -M options, checkpatch reports error:
>
> [tangyt@titan linux-pm]$ ./scripts/checkpatch.pl 0002-cpufreq-qoriq-rename-the-driver.patch
> WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
> #15:
>  drivers/cpufreq/{ppc-corenet-cpufreq.c => qoriq-cpufreq.c} | 0
>
> ERROR: Does not appear to be a unified-diff format patch
>
> total: 1 errors, 1 warnings, 0 lines checked
>
> 0002-cpufreq-qoriq-rename-the-driver.patch has style problems, please review.
>
> I just rename it and do not change anyting. Isn't that allowed?

Ignore these warnings.

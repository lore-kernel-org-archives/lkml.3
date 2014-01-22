Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbaAVE7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 23:59:25 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:49018 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbaAVE66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 23:58:58 -0500
MIME-Version: 1.0
In-Reply-To: <1390339396-3479-69-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
	<1390339396-3479-69-git-send-email-paul.gortmaker@windriver.com>
Date: Wed, 22 Jan 2014 10:28:57 +0530
Message-ID: <CAKohpo=oWrX2SF5GWYoGzC+cuZeOx_wappTFfOy9vCpBush+BQ@mail.gmail.com>
Subject: Re: [PATCH 68/73] drivers/cpufreq: delete non-required instances of <linux/init.h>
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Kevin Hilman <khilman@deeprootsystems.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 January 2014 02:53, Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> None of these files are actually using any __init type directives
> and hence don't need to include <linux/init.h>.  Most are just a
> left over from __devinit and __cpuinit removal, or simply due to
> code getting copied from one driver to the next.
>
> Cc: Kevin Hilman <khilman@deeprootsystems.com>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: cpufreq@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  drivers/cpufreq/omap-cpufreq.c    | 1 -
>  drivers/cpufreq/powernow-k8.c     | 1 -
>  drivers/cpufreq/s3c2412-cpufreq.c | 1 -
>  drivers/cpufreq/s3c2440-cpufreq.c | 1 -
>  drivers/cpufreq/spear-cpufreq.c   | 1 -
>  drivers/cpufreq/speedstep-lib.c   | 1 -
>  6 files changed, 6 deletions(-)

We have discussed this in past where I pointed out this file is required
by stuff like module_init, what happened to that query ?

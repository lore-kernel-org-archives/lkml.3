Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015AbaEEOfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:35:48 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:59449 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909AbaEEOfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:35:45 -0400
MIME-Version: 1.0
In-Reply-To: <1399296830-13056-3-git-send-email-nm@ti.com>
References: <1399296830-13056-1-git-send-email-nm@ti.com>
	<1399296830-13056-3-git-send-email-nm@ti.com>
Date: Mon, 5 May 2014 20:05:44 +0530
Message-ID: <CAKohpom0nq_v0wzaLtU4NxRxJwLgrUB1K8+9QtkanibeznEi4g@mail.gmail.com>
Subject: Re: [PATCH 2/2] PM / OPP: Move cpufreq specific OPP functions out of
 generic OPP library
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 May 2014 19:03, Nishanth Menon <nm@ti.com> wrote:
> CPUFreq specific helper functions for OPP (Operating Performance Points)
> now use generic OPP functions that allow CPUFreq to be be moved back
> into CPUFreq framework. This allows for independent modifications
> or future enhancements as needed isolated to just CPUFreq framework
> alone.
>
> Here, we just move relevant code and documentation to make this part of
> CPUFreq infrastructure.
>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: Kevin Hilman <khilman@deeprootsystems.com>
> Cc: cpufreq@vger.kernel.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-omap@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

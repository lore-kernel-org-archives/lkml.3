Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab3FZLDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:03:32 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:43046 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab3FZLDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:03:30 -0400
MIME-Version: 1.0
In-Reply-To: <1371661969-7660-4-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1371661969-7660-1-git-send-email-l.majewski@samsung.com>
	<1371661969-7660-4-git-send-email-l.majewski@samsung.com>
Date: Wed, 26 Jun 2013 16:33:30 +0530
Message-ID: <CAKohpom2h3R4=B9e8ZvqEUmudB19-cnv3Lgp0=BkxgYdGA6CUA@mail.gmail.com>
Subject: Re: [PATCH v4 3/7] cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code
 to work with common boost solution
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
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 June 2013 22:42, Lukasz Majewski <l.majewski@samsung.com> wrote:
> diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c

>  static unsigned int acpi_pstate_strict;
> -static bool boost_enabled, boost_supported;
> +static bool boost_enabled;

Instead of this variable use cpufreq_boost_enabled() directly.

And then this patch may change as well..

I couldn't find any more issues with this patch but some Intel guy must
review it.

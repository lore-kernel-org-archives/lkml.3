Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab3HZFfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 01:35:16 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:58898 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab3HZFfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 01:35:13 -0400
MIME-Version: 1.0
In-Reply-To: <1376388505-30233-5-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1376388505-30233-1-git-send-email-l.majewski@samsung.com>
	<1376388505-30233-5-git-send-email-l.majewski@samsung.com>
Date: Mon, 26 Aug 2013 11:05:13 +0530
Message-ID: <CAKohpon0+A0y3toZg_ckYuW7U0BXsvBvxBkDDyY9w+sKdDw_rQ@mail.gmail.com>
Subject: Re: [PATCH v7 4/7] cpufreq:boost:Kconfig: Provide support for
 software managed BOOST
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 August 2013 15:38, Lukasz Majewski <l.majewski@samsung.com> wrote:
> For safety reasons new flag - CONFIG_CPU_FREQ_BOOST_SW has been added.
> Only after selecting "EXYNOS Frequency Overclocking - Software" Kconfig
> option the software managed boost is enabled. It also selects thermal
> subsystem to be compiled in. Thermal is necessary for disabling boost
> and cooling down the device when overheating detected.
>
> Boost _MUST_NOT_ work without thermal subsystem with properly defined
> overheating temperatures.
>
> This option doesn't affect x86's ACPI hardware managed boost support
> (i.e. Intel, AMD). In this situation boost management is embedded at
> hardware.
>
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>
> ---
> Changes for v7:
> - Remove superfluous "default n" definition
> - Generic CPU_FREQ_BOOST_SW depends on THERMAL

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

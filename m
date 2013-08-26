Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab3HZFcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 01:32:11 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:35970 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab3HZFcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 01:32:08 -0400
MIME-Version: 1.0
In-Reply-To: <1376388505-30233-3-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1376388505-30233-1-git-send-email-l.majewski@samsung.com>
	<1376388505-30233-3-git-send-email-l.majewski@samsung.com>
Date: Mon, 26 Aug 2013 11:02:07 +0530
Message-ID: <CAKohpok2aiBZDy+x17uQr1=0_dwz9drAn9ah9=vmyY+t0G35sw@mail.gmail.com>
Subject: Re: [PATCH v7 2/7] cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code
 to work with common boost solution
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
> The Intel's hardware based boost solution driver has been changed to cooperate with
> common cpufreq boost framework.
>
> The global sysfs boost attribute entry code (/sys/devices/system/cpu/cpufreq/boost)
> has been moved to a core cpufreq code. This attribute is now only visible,
> when cpufreq driver supports it.
>
> The _store_boost() function has been redesigned to be used as set_boost
> callback.
>
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>
> ---
> Changes for v7:
> - Remove superfluous acpi_cpufreq_driver.boost_supported = false at
>   acpi_cpufreq_boost_init()

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

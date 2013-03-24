Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab3CXP7Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 11:59:16 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:40070 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab3CXP7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 11:59:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAG9S4UjFJ2hLD7fXJ7D3Le=GC3xRZaD8vZ+YQOav5q+fnKO+Qw@mail.gmail.com>
References: <CAG9S4UjMeRZECAiigZVLTU4av2ZJNBukyUAoCmiYRjtkdThhFw@mail.gmail.com>
	<CAKohpokBySA5uaTTAwF5tmUr-_+W04Ki_f6cWTLu7n1C3Tcqog@mail.gmail.com>
	<CAG9S4UjFJ2hLD7fXJ7D3Le=GC3xRZaD8vZ+YQOav5q+fnKO+Qw@mail.gmail.com>
Date: Sun, 24 Mar 2013 21:29:13 +0530
Message-ID: <CAKohpomTg9QRo15sA=vbG+zuJvMhzi1=T1H6X=M-TsCtzNsFLw@mail.gmail.com>
Subject: Re: [REGRESSION] [CPUFREQ] 3.9.0-rcX
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 March 2013 21:06, Maciej Rutecki <maciej.rutecki@gmail.com> wrote:
> -rc4 + yours path, config based on -rc3:
>
> # CONFIG_X86_INTEL_PSTATE is not set
> # CONFIG_X86_PCC_CPUFREQ is not set
>
> (use acpi-cpufreq)
>
> Freq. seems be ok. 'ondemand' governor works as expected.

Thanks for testing it. I have sent this patch upstream now with your Tested-by.

--
viresh

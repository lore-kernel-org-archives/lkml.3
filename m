Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab3CXPg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 11:36:28 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:53414 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab3CXPg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 11:36:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokBySA5uaTTAwF5tmUr-_+W04Ki_f6cWTLu7n1C3Tcqog@mail.gmail.com>
References: <CAG9S4UjMeRZECAiigZVLTU4av2ZJNBukyUAoCmiYRjtkdThhFw@mail.gmail.com>
	<CAKohpokBySA5uaTTAwF5tmUr-_+W04Ki_f6cWTLu7n1C3Tcqog@mail.gmail.com>
Date: Sun, 24 Mar 2013 16:36:25 +0100
Message-ID: <CAG9S4UjFJ2hLD7fXJ7D3Le=GC3xRZaD8vZ+YQOav5q+fnKO+Qw@mail.gmail.com>
Subject: Re: [REGRESSION] [CPUFREQ] 3.9.0-rcX
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/24 Viresh Kumar <viresh.kumar@linaro.org>:
> On 24 March 2013 19:41, Maciej Rutecki <maciej.rutecki@gmail.com> wrote:
>> (long e-mail, sorry ;-))
>
> Don't be, it was useful :)
>
>> Last known good: 3.8.0
>>
>> Short description:
>> 1. On -rc3, after s2ram cpufreq does not set CPU on max frequency on high
>> load (on battery).
>
> Try attached patch for this.
>
-rc4 + yours path, config based on -rc3:

# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set

(use acpi-cpufreq)

Freq. seems be ok. 'ondemand' governor works as expected.

Regards

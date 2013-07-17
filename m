Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab3GQH73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 03:59:29 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:62630 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab3GQH71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 03:59:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130717093614.1ee4839e@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1372927830-2949-1-git-send-email-l.majewski@samsung.com>
	<1372927830-2949-8-git-send-email-l.majewski@samsung.com>
	<CAKohpo=oB_4gGtNn6jvxSCp665pOq6oqeTCCyGzmN_eWqt0Lhg@mail.gmail.com>
	<20130716133319.49ed0838@amdc308.digital.local>
	<CAKohponeZ15ruJA9__V70u1Ztr4F9aT+zBinMT5Ewyew53rbyQ@mail.gmail.com>
	<20130717093614.1ee4839e@amdc308.digital.local>
Date: Wed, 17 Jul 2013 13:29:26 +0530
Message-ID: <CAKohpo=n6JBWZVmdLqUjs0kUVj3BvUs9gNcVu4B7_2Z7ezFgVw@mail.gmail.com>
Subject: Re: [PATCH v5 7/7] Documentation:cpufreq:boost: Update BOOST documentation
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 July 2013 13:06, Lukasz Majewski <l.majewski@samsung.com> wrote:
> At v4 there was the old acpi-cpufreq.c behaviour preserved (with always
> exporting boost - when not supported ro, when supported rw).
>
> Due to Rafael and Dirk comments it has been rewritten at v5:
>
> http://thread.gmane.org/gmane.linux.kernel/1511831/match=patch+v4+2+7+cpufreq+add+boost+frequency+support+core
>
>
>>
>> Rafael Said:
>> "Simple: Export it only when supported."
>               [*]
>
>>
>> AND
>>
>> "Don't change behavior of acpi-cpufreq driver"
>               [**]
>>
>> If you see acpi-cpufreq driver carefully, it always creates "boost"
>> sysfs entry. If its not supported then it creates a read only entry.
>
> For me those two statements [*] and [**] contradict:
>
> At v5:
> 1. ARM - export "boost" only when supported (rw)
> 2. x86 - export boost only when x86 supports it (as rw). When x86
>          doesn't support HW boost - DO NOT export it at all.
>
> At v4:
> 1. ARM - export "boost" only when supported (rw)
> 2. x86 - always export boost - no matter if supported or not. If not
>          supported, then export it as ro only.

Okay, there is some confusion..

I have raised a query on your v4 mail.. lets see what people have to say.

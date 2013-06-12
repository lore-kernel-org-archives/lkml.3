Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab3FLO2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:28:06 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:45259 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab3FLO2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:28:03 -0400
MIME-Version: 1.0
In-Reply-To: <201306121447.00139.arnd@arndb.de>
References: <cover.1371022830.git.viresh.kumar@linaro.org>
	<201306121447.00139.arnd@arndb.de>
Date: Wed, 12 Jun 2013 19:58:00 +0530
Message-ID: <CAKohpont-8ZNDWx0n1G8ks=evfoJi3kQ5idjmeguyT8BWgTY4w@mail.gmail.com>
Subject: Re: [PATCH 00/11] CPUFreq Kconfig fixes
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 June 2013 18:16, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 12 June 2013, Viresh Kumar wrote:
>> Recently Arnd sent few fixes where drivers were using APIs from freq_table.c but
>> haven't selected CPU_FREQ_TABLE. Based on that, I just crossed checked all the
>> places where it should be selected and where it shouldn't be. These are fixes
>> around that.
>>
>> I have applied these in my cpufreq-kconfig-fixes branch. Will send you a pull
>> request separately once I get some Acks (will wait for few days).
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
>
> I don't see a patch for big.LITTLE in either linux-next or this series. Did you
> miss that or has it just not made into linux-next yet?

My ARM branch was pulled in by Rafael, 2 days back. Don't know why didn't
you saw that.

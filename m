Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab3CaFY2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 01:24:28 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:44769 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab3CaFY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 01:24:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokq+JJF2Ec3=_QF5dk_w9tMuKZ0trtcgXbC1if=HXEBRg@mail.gmail.com>
References: <cover.1364205812.git.viresh.kumar@linaro.org> <2aa937c3d81776f01c2c1d6fcfcb08ba74163b53.1364205812.git.viresh.kumar@linaro.org>
 <CAKohpokq+JJF2Ec3=_QF5dk_w9tMuKZ0trtcgXbC1if=HXEBRg@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sun, 31 Mar 2013 13:24:06 +0800
Message-ID: <CAMPhdO9WbCdJq8NdoOjW2Jreka2dSRrNyit_7xrAbX_haEqNGQ@mail.gmail.com>
Subject: Re: [PATCH 6/9] cpufreq: pxa3xx: move cpufreq driver to drivers/cpufreq
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, arvind.chauhan@arm.com,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 31, 2013 at 11:52 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Eric/Haojian,
>
> On 25 March 2013 15:41, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> This patch moves cpufreq driver of ARM based pxa3xx platform to drivers/cpufreq.
>>
>> Cc: Eric Miao <eric.y.miao@gmail.com>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

>> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>  arch/arm/mach-pxa/Makefile                                           | 1 -
>>  arch/arm/mach-pxa/include/mach/generic.h                             | 1 +
>>  drivers/cpufreq/Makefile                                             | 1 +
>>  .../mach-pxa/cpufreq-pxa3xx.c => drivers/cpufreq/pxa3xx-cpufreq.c    | 5 +----
>>  4 files changed, 3 insertions(+), 5 deletions(-)
>>  create mode 100644 arch/arm/mach-pxa/include/mach/generic.h
>>  rename arch/arm/mach-pxa/cpufreq-pxa3xx.c => drivers/cpufreq/pxa3xx-cpufreq.c (98%)
>
> Can i have your Ack or views about 6/9 and 7/9 Patch?

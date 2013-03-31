Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab3CaGpw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 02:45:52 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:34032 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab3CaGpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 02:45:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAMPhdO9WbCdJq8NdoOjW2Jreka2dSRrNyit_7xrAbX_haEqNGQ@mail.gmail.com>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
	<2aa937c3d81776f01c2c1d6fcfcb08ba74163b53.1364205812.git.viresh.kumar@linaro.org>
	<CAKohpokq+JJF2Ec3=_QF5dk_w9tMuKZ0trtcgXbC1if=HXEBRg@mail.gmail.com>
	<CAMPhdO9WbCdJq8NdoOjW2Jreka2dSRrNyit_7xrAbX_haEqNGQ@mail.gmail.com>
Date: Sun, 31 Mar 2013 12:15:49 +0530
Message-ID: <CAKohpok6vQtbHC0u+XCbPLyJf3w=v=LUNqZB2eJ5msy7=3zWgA@mail.gmail.com>
Subject: Re: [PATCH 6/9] cpufreq: pxa3xx: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, arvind.chauhan@arm.com,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 March 2013 10:54, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Sun, Mar 31, 2013 at 11:52 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> Eric/Haojian,
>>
>> On 25 March 2013 15:41, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>> This patch moves cpufreq driver of ARM based pxa3xx platform to drivers/cpufreq.
>>>
>>> Cc: Eric Miao <eric.y.miao@gmail.com>
>
> Acked-by: Eric Miao <eric.y.miao@gmail.com>
>
>>> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
>>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>>> ---
>>>  arch/arm/mach-pxa/Makefile                                           | 1 -
>>>  arch/arm/mach-pxa/include/mach/generic.h                             | 1 +
>>>  drivers/cpufreq/Makefile                                             | 1 +
>>>  .../mach-pxa/cpufreq-pxa3xx.c => drivers/cpufreq/pxa3xx-cpufreq.c    | 5 +----
>>>  4 files changed, 3 insertions(+), 5 deletions(-)
>>>  create mode 100644 arch/arm/mach-pxa/include/mach/generic.h
>>>  rename arch/arm/mach-pxa/cpufreq-pxa3xx.c => drivers/cpufreq/pxa3xx-cpufreq.c (98%)
>>
>> Can i have your Ack or views about 6/9 and 7/9 Patch?

Is this for both the patches??

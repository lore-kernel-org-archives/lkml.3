Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422791AbaD3PhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:37:13 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:44157 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422771AbaD3PhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:37:11 -0400
Message-ID: <536118A2.2060204@semaphore.gr>
Date: Wed, 30 Apr 2014 18:37:06 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>, linux-doc@vger.kernel.org,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Simon Horman <horms@verge.net.au>, Sekhar Nori <nsekhar@ti.com>,
        Samuel Ortiz <samuel@sortiz.org>
Subject: Re: [PATCH v5 0/8] Introduce new cpufreq helper macros
References: <535AC247.3070907@semaphore.gr> <CAKohpok-74uK5k-adxjmEy71=vF8V7MaBwdCD1Vb2ats7FHi_A@mail.gmail.com> <535FCDBD.6080500@semaphore.gr> <1621123.rMC9JtD3Mo@vostro.rjw.lan>
In-Reply-To: <1621123.rMC9JtD3Mo@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/04/2014 01:26 πμ, Rafael J. Wysocki wrote:
> On Tuesday, April 29, 2014 07:05:17 PM Stratos Karafotis wrote:
>> On 29/04/2014 07:17 πμ, Viresh Kumar wrote:
>>> On 26 April 2014 01:45, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>>>> This patch set introduces two freq_table helper macros which
>>>> can be used for iteration over cpufreq_frequency_table and
>>>> makes the necessary changes to cpufreq core and drivers that
>>>> use such an iteration procedure.
>>>>
>>>> The motivation was a usage of common procedure to iterate over
>>>> cpufreq_frequency_table across all drivers and cpufreq core.
>>>>
>>>> This was tested on a x86_64 platform.
>>>> Most files compiled successfully but unfortunately I was not
>>>> able to compile sh_sir.c pasemi_cpufreq.c and ppc_cbe_cpufreq.c
>>>> due to lack of cross compiler.
>>>>
>>>> Changelog
>>>>
>>>> v4 -> v5
>>>>         - Fix warnings in printk format specifier for 32 bit
>>>>           architectures in freq_table.c, longhaul, pasemi, ppc_cbe
>>>
>>> Doesn't look much has changed and so it stays as is:
>>>
>>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>>>
>>
>> Thank you very much!
> 
> I've applied the series to my bleeding-edge branch, will move it to linux-next
> after build testing later this week.
> 
> Thanks!
> 

Thanks so much!


Stratos Karafotis

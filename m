Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaBCQtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:49:49 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53790 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaBCQts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:49:48 -0500
Message-ID: <52EFC8A4.2060906@linaro.org>
Date: Tue, 04 Feb 2014 00:49:40 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: a LLC sched domain bug for panda board?
References: <52EFC11A.8010709@linaro.org> <CAKfTPtDD9g6PPx=cDkbH2VDO0k1HDAjcxwxeW2YLXwL5T4d6NA@mail.gmail.com> <CAKfTPtDJ267W9UMRj-pgyha0yf1L-VWBMKgi+QdVEA4zFJYXLw@mail.gmail.com>
In-Reply-To: <CAKfTPtDJ267W9UMRj-pgyha0yf1L-VWBMKgi+QdVEA4zFJYXLw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 12:28 AM, Vincent Guittot wrote:
> On 3 February 2014 17:27, Vincent Guittot <vincent.guittot@linaro.org> wrote:
>> Have you checked that CONFIG_SCHED_LC is set ?
> 
> sorry it's CONFIG_SCHED_MC

Thanks for reminder! no it wasn't set. Does it means
arch/arm/configs/omap2plus_defconfig need add this config?

> 
>>
>>
>> On 3 February 2014 17:17, Alex Shi <alex.shi@linaro.org> wrote:
>>> I just run the 3.14-rc1 kernel on panda board. The only domain for it is
>>> 'CPU' domain, but this domain has no SD_SHARE_PKG_RESOURCES setting, it
>>> has no sd_llc.
>>>
>>> Guess the right domain for this board should be MC. So is it a bug?
>>>
>>> ..
>>> /proc/sys/kernel/sched_domain/cpu0/domain0/name:CPU
>>> ..
>>> /proc/sys/kernel/sched_domain/cpu1/domain0/name:CPU
>>>
>>> --
>>> Thanks
>>>     Alex
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Thanks
    Alex

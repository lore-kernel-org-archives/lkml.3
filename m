Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab3LJGdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 01:33:37 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:45022 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab3LJGdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 01:33:36 -0500
Message-ID: <52A6B5BB.3060506@linaro.org>
Date: Tue, 10 Dec 2013 14:33:31 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        preeti@linux.vnet.ibm.com, "len.brown@intel.com" <len.brown@intel.com>
Subject: Re: questions of cpuidle
References: <52A5C846.30308@linaro.org> <52A5D0E0.7050201@linaro.org>
In-Reply-To: <52A5D0E0.7050201@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 10:17 PM, Daniel Lezcano wrote:
> 
> Concerning the wake up of the cpu: the cpu disabled the irq and goes to
> sleep, it is up to the firmware to wake up the cpu when an interrupt
> occurs. It will exits its sleep state, call clock_events_notify(EXIT),
> by this way re-switching to the local timer, and then re-enabling the
> local interrupt which leads to the interrupt handler.

Thanks a lots for excellent article and detailed explains!

So, if the firmware is in response to wake up cpu. that means there is a
unit which control the firmware and it can not be power down. Do you
know which unit running the firmware to wake up deep idle CPU.
And does the wake up pass via GIC to CPU? If so, does the GIC need keep
awake when all cpu idle? If not, how the firmware give the interrupt to
CPU? And I am wondering if the deep idle cpu voltage get to near 0.
How the cpu get the interrupt signal?

> 
> There are some more informations in the wiki page [1].
> 
>   -- Daniel
> 
> [1] https://wiki.linaro.org/WorkingGroups/PowerManagement/Doc/WakeUpSources


-- 
Thanks
    Alex

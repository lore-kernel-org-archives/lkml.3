Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786Ab3KMK3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 05:29:34 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:51931 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab3KMK3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 05:29:32 -0500
Message-ID: <5283548A.8050903@linaro.org>
Date: Wed, 13 Nov 2013 11:29:30 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 5/7] clocksource/cadence_ttc: Overhaul clocksource frequency
 adjustment
References: <1383945677-29674-1-git-send-email-soren.brinkmann@xilinx.com>	<1383945677-29674-6-git-send-email-soren.brinkmann@xilinx.com>	<52827B11.5040308@linaro.org> <CAKohpo=KaM97jJ2MnZxSeBz=Mf9cSmzk_EFQTL=EVPPvSH=Wag@mail.gmail.com>
In-Reply-To: <CAKohpo=KaM97jJ2MnZxSeBz=Mf9cSmzk_EFQTL=EVPPvSH=Wag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 09:03 AM, Viresh Kumar wrote:
> On 13 November 2013 00:31, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>> Hmm, it could be interesting if Viresh can give its opinion on this patch
>> [cc'ed].
>
> I am not sure if I understood the problem completely, but if this is about
> not allowing frequency transitions from cpufreq when we have started to
> suspend our system, then you must have a look at this thread:
>
> https://lkml.org/lkml/2013/10/24/369

Thanks Viresh for the pointer.


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


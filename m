Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbaGQKcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:32:03 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55440 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbaGQKcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:32:00 -0400
Message-ID: <53C7A61C.7030704@linaro.org>
Date: Thu, 17 Jul 2014 12:31:56 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] AT91: PIT: Cleanups and move to drivers/clocksource
References: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com> <20140710075105.GA27469@lukather> <20140717095020.GB20328@lukather>
In-Reply-To: <20140717095020.GB20328@lukather>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 11:50 AM, Maxime Ripard wrote:
> On Thu, Jul 10, 2014 at 09:51:05AM +0200, Maxime Ripard wrote:
>> Hi Daniel,
>>
>> On Tue, Jul 01, 2014 at 11:33:13AM +0200, Maxime Ripard wrote:
>>> Hi everyone,
>>>
>>> This series cleans up the PIT driver in order for it to not depend on
>>> anything in mach-at91 anymore, and in the end move it out of
>>> mach-at91.
>>>
>>> Along the way, these patches also do a bit of cleanup.
>>>
>>> This has been tested on a G45-EK without DT and an Xplained with DT.
>>>
>>
>> Even though most of this patches are not clocksource related, it would
>> be great if we could at least get an acked-by on the last patch that
>> moves the driver to drivers/clocksource, since it pretty much becomes
>> your burden :)
>
> Ping?

Hi,

I am in vacation right now. I will review the patches in the next two days.

Thanks
   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


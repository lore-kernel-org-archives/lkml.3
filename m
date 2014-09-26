Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbaIZLeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:34:11 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:47060 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbaIZLeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:34:09 -0400
Message-ID: <54254F2E.2050804@linaro.org>
Date: Fri, 26 Sep 2014 13:34:06 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Nathan Lynch <nathan_lynch@mentor.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sonny Rao <sonnyrao@chromium.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] clocksource: arm_arch_timer: change clocksource
 name if CP15 unavailable
References: <1411052390-27238-1-git-send-email-nathan_lynch@mentor.com> <1411052390-27238-2-git-send-email-nathan_lynch@mentor.com> <54250FFE.2050605@linaro.org> <20140926092604.GC22293@arm.com>
In-Reply-To: <20140926092604.GC22293@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2014 11:26 AM, Will Deacon wrote:
> On Fri, Sep 26, 2014 at 08:04:30AM +0100, Daniel Lezcano wrote:
>> On 09/18/2014 04:59 PM, Nathan Lynch wrote:
>>> The arm and arm64 VDSOs need CP15 access to the architected counter.
>>> If this is unavailable (which is allowed by ARM v7), indicate this by
>>> changing the clocksource name to "arch_mem_counter" before registering
>>> the clocksource.
>>>
>>> Suggested by Stephen Boyd.
>>>
>>> Signed-off-by: Nathan Lynch <nathan_lynch@mentor.com>
>>> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
>>
>> Hi Nathan,
>>
>> is it possible to have the acked-by of the different maintainers for the
>> other patches ?
>
> FWIW: I acked the series:
>
>    http://lists.infradead.org/pipermail/linux-arm-kernel/2014-September/289143.html
>
> There's ongoing debate about whether or not we should have a vdso, but this
> series still makes sense in isolation.

Ok. Thanks for the clarification.


> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


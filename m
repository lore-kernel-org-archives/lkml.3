Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbaIZOzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:55:36 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:48488 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbaIZOzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:55:32 -0400
Message-ID: <54257E5D.5060600@mentor.com>
Date: Fri, 26 Sep 2014 09:55:25 -0500
From: Nathan Lynch <Nathan_Lynch@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sonny Rao <sonnyrao@chromium.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] clocksource: arm_arch_timer: change clocksource
 name if CP15 unavailable
References: <1411052390-27238-1-git-send-email-nathan_lynch@mentor.com> <1411052390-27238-2-git-send-email-nathan_lynch@mentor.com> <54250FFE.2050605@linaro.org>
In-Reply-To: <54250FFE.2050605@linaro.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 09/26/2014 02:04 AM, Daniel Lezcano wrote:
> On 09/18/2014 04:59 PM, Nathan Lynch wrote:
>> The arm and arm64 VDSOs need CP15 access to the architected counter.
>> If this is unavailable (which is allowed by ARM v7), indicate this by
>> changing the clocksource name to "arch_mem_counter" before registering
>> the clocksource.
>>
>> Suggested by Stephen Boyd.
>>
>> Signed-off-by: Nathan Lynch <nathan_lynch@mentor.com>
>> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> Hi Nathan,
> 
> is it possible to have the acked-by of the different maintainers for the
> other patches ?

As Will said, he acked the series.

> Are these patches targeted to be merged for 3.18 ?

3.18 is preferable, if it's not too late.  But nothing will break if it
needs to wait.

Thanks,
Nathan


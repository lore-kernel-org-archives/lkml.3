Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab3LROxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:53:52 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:49561 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab3LROxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:53:50 -0500
Message-ID: <52B1B6FF.7000400@linaro.org>
Date: Wed, 18 Dec 2013 15:53:51 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 3/9] clocksource/cadence_ttc: Store timer frequency
 in driver data
References: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com> <1385514296-26702-4-git-send-email-soren.brinkmann@xilinx.com> <5cff3201-db97-4061-a686-bf79ac17d4fe@CO1EHSMHS006.ehs.local>
In-Reply-To: <5cff3201-db97-4061-a686-bf79ac17d4fe@CO1EHSMHS006.ehs.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 08:21 PM, Sören Brinkmann wrote:
> Hi Daniel,
>
> On Tue, Nov 26, 2013 at 05:04:50PM -0800, Soren Brinkmann wrote:
>> It is not allowed to call clk_get_rate() from interrupt context. To
>> avoid such calls the timer input frequency is stored in the driver's
>> data struct which makes it accessible to the driver in any context.
>>
>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>
> I doubt that we'll resolve all issues with this series before the
> holidays or even the next merge window. Could you take this patch into
> your tree for 3.14? It is not directly related to the cpufreq work and
> fixes an actual issue that triggers a kernel WARN under some condition
> (I missed preserving the details and the trace). That would take the
> easy stuff out of the way and we can focus on the more controversial
> changes.

You are asking to take it for 3.14 but shouldn't it go as a 3.13 fix ?

   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbaAIX7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 18:59:49 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:42840 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbaAIX72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:59:28 -0500
Message-ID: <52CF37DF.4000309@codeaurora.org>
Date: Thu, 09 Jan 2014 15:59:27 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/7] ARM: perf_event: Silence sparse warning
References: <1389221984-10973-1-git-send-email-sboyd@codeaurora.org> <1389221984-10973-2-git-send-email-sboyd@codeaurora.org> <20140109104519.GA17838@mudshark.cambridge.arm.com>
In-Reply-To: <20140109104519.GA17838@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/14 02:45, Will Deacon wrote:
> Hi Stephen,
>
> On Wed, Jan 08, 2014 at 10:59:38PM +0000, Stephen Boyd wrote:
>> arch/arm/kernel/perf_event_cpu.c:274:25: warning: incorrect type in assignment (different modifiers)
>> arch/arm/kernel/perf_event_cpu.c:274:25: expected int ( *init_fn )( ... )
>> arch/arm/kernel/perf_event_cpu.c:274:25: got void const *const data
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
> Given that the rest of the series depends on the change to the percpu IRQ
> stuff, I think you can just send this patch to Russell's patch system with
> my ack:
>
>   Acked-by: Will Deacon <will.deacon@arm.com>
>

Thanks. It's 7937/1.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


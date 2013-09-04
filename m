Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935222Ab3IDQ35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:29:57 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44927 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934905Ab3IDQ3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:29:55 -0400
Message-ID: <52276001.8070801@codeaurora.org>
Date: Wed, 04 Sep 2013 09:29:53 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, arnd@arndb.de,
        linux-sh@vger.kernel.org, rob.herring@calxeda.com, olof@lixom.net,
        santosh.shilimkar@ti.com, grant.likely@linaro.org, tglx@linutronix.de
Subject: Re: [PATCH] clocksource: em_sti: Set cpu_possible_mask to fix SMP
 broadcast
References: <20130904080151.24562.91334.sendpatchset@w520> <20130904083727.GE17329@verge.net.au> <5226F2E2.3070202@linaro.org>
In-Reply-To: <5226F2E2.3070202@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/13 01:44, Daniel Lezcano wrote:
>
>> On Wed, Sep 04, 2013 at 05:01:51PM +0900, Magnus Damm wrote:
>>> From: Magnus Damm <damm@opensource.se>
>>>
>>> Update the STI driver by setting cpu_possible_mask to make EMEV2
>>> SMP work as expected together with the ARM broadcast timer.
>>>
>>> This breakage was introduced by:
>>>
>>> f7db706 ARM: 7674/1: smp: Avoid dummy clockevent being preferred over real hardware clock-event
>>>
>>> Without this fix SMP operation is broken on EMEV2 since no
>>> broadcast timer interrupts trigger on the secondary CPU cores.
>>>
>>> Signed-off-by: Magnus Damm <damm@opensource.se>
>> Tested-by: Simon Horman <horms+renesas@verge.net.au>
>>
>> I will let this sit for a few days to see if there is any further feedback.

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


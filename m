Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab3KHXjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 18:39:16 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51349 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752Ab3KHXjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 18:39:14 -0500
Message-ID: <527D7621.2000105@codeaurora.org>
Date: Fri, 08 Nov 2013 15:39:13 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Kevin Hilman <khilman@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH] ARM: Support arch_irq_work_raise() via self IPIs
References: <526DBEAA.4030707@linaro.org>	<1382984701-2371-1-git-send-email-sboyd@codeaurora.org>	<878uxcq1m7.fsf@linaro.org>	<20131029060058.GD21983@codeaurora.org>	<CAOesGMhjC=NDn4YiY4tQ3ZcW_rK9_qOY03CVD1eyVFC74ucdrA@mail.gmail.com>	<CAOesGMhB2Akf_B2_J3LVdt1bDvcsTE7+8Kq=NvsXmkf3EwGsiw@mail.gmail.com>	<527D5D5C.2080409@codeaurora.org> <CAOesGMhyPaMUs3XJshqZ-KYhtWhenttq7qDpF0+4dQ9PvBYVGA@mail.gmail.com>
In-Reply-To: <CAOesGMhyPaMUs3XJshqZ-KYhtWhenttq7qDpF0+4dQ9PvBYVGA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/13 15:35, Olof Johansson wrote:
> On Fri, Nov 8, 2013 at 1:53 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>
>> Ah yes. We don't have IPI support on UP kernels but SMP_ON_UP exposes
>> arch_irq_work_raise(). How about this? We should just skip this function
>> if we're running on UP.
> Yep.
>
> Tested-by: Olof Johansson <olof@lixom.net>
>
> Send it to Russell's tracker, plz.
>

Thanks. 7887/1.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab3FZSCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 14:02:15 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35077 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab3FZSCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 14:02:14 -0400
Message-ID: <51CB2CA4.20701@codeaurora.org>
Date: Wed, 26 Jun 2013 14:02:12 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Add support for LPAE style CONTEXTIDR
References: <1372080405-13365-1-git-send-email-cov@codeaurora.org> <20130624140424.GA24861@mudshark.cambridge.arm.com> <51C85A0D.3070400@codeaurora.org> <20130624145303.GA25582@mudshark.cambridge.arm.com> <51C8627A.5000106@codeaurora.org> <20130626171138.GF10333@mudshark.cambridge.arm.com>
In-Reply-To: <20130626171138.GF10333@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 01:11 PM, Will Deacon wrote:
> On Mon, Jun 24, 2013 at 04:15:06PM +0100, Christopher Covington wrote:
>> On 06/24/2013 10:53 AM, Will Deacon wrote:
>>> On Mon, Jun 24, 2013 at 03:39:09PM +0100, Christopher Covington wrote:
>>>> Hi Will,
>>>>
>>>> On 06/24/2013 10:04 AM, Will Deacon wrote:
>>>> [...]
>>>>
>>>>> What's the advantage of this approach, other than you get an extra byte's
>>>>> worth of PID?
>>>>
>>>> In my view, the real advantage is that the the PID is located where people
>>>> reading ARM Architecture Reference Manual are told they can find it.
>>>
>>> Perhaps, but I'd usually expect a debugger or trace tools to do something
>>> with the PID, and they likely expect it to be shifted, so you can't really
>>> win.
>>
>> But reading and implementing the architecture *is* winning! LOL. I'll file a
>> ticket with the architecture folks and see what they think.
> 
> ...aaand that came full circle :)
> 
> I think the conclusion is that Linux PID != CONTEXTIDR.PROCID.

Fair enough. What would you think then of configuration options to write other
identifiers like the process group ID to the PROCID field?

> I'm just trying to keep it easy for the tools.

What tools exactly? The ones I've been working with are software model plugins
supporting AArch32 and AArch64, which may be very different from the ones
you're concerned about.

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbaA2OAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:00:18 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:50465 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaA2OAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:00:16 -0500
Message-ID: <52E9096D.9070800@codeaurora.org>
Date: Wed, 29 Jan 2014 09:00:13 -0500
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] ARM: hw_breakpoint: Add ARMv8 support
References: <20140128183851.GK2885@mudshark.cambridge.arm.com> <1390935112-28465-1-git-send-email-cov@codeaurora.org> <20140129105722.GD26622@mudshark.cambridge.arm.com>
In-Reply-To: <20140129105722.GD26622@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On 01/29/2014 05:57 AM, Will Deacon wrote:
> Hi Christopher,
> 
> On Tue, Jan 28, 2014 at 06:51:51PM +0000, Christopher Covington wrote:
>> Add the trivial support necessary to get hardware breakpoints
>> working for GDB on ARMv8 simulators running in AArch32 mode.
>>
>> Acked-by: Will Deacon <will.deacon@arm.com>
>> Signed-off-by: Christopher Covington <cov@codeaurora.org>
>> ---
>>
>>  v3: assume for now that ARMv9 and later will update FSR
> 
> Please can you stick this into the patch system? I don't have any other
> hw_breakpoint changes queued, so I doubt I'll send a pull for 3.15.

Thanks for your review. Sounds good; will do.

Regards,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.

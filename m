Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab3G3Vsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 17:48:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37053 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab3G3Vsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 17:48:41 -0400
Message-ID: <51F834B7.4060109@codeaurora.org>
Date: Tue, 30 Jul 2013 14:48:39 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ARM: msm: Remove pen_release usage
References: <1372461962-17197-1-git-send-email-rvaswani@codeaurora.org> <1372461962-17197-2-git-send-email-rvaswani@codeaurora.org> <6FE2B9F1-31C1-410A-93BE-9EFA2C6795C0@codeaurora.org>
In-Reply-To: <6FE2B9F1-31C1-410A-93BE-9EFA2C6795C0@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/26/2013 10:48 AM, Kumar Gala wrote:
> On Jun 28, 2013, at 6:25 PM, Rohit Vaswani wrote:
>
>> pen_release is no longer required as the synchronization
>> is now managed by generic arm code.
>> This is done as suggested in https://lkml.org/lkml/2013/6/4/184
>>
>> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
>> ---
>> arch/arm/mach-msm/headsmp.S | 41 -----------------------------------------
>> arch/arm/mach-msm/hotplug.c | 31 ++++---------------------------
>> arch/arm/mach-msm/platsmp.c | 35 +++--------------------------------
>> 3 files changed, 7 insertions(+), 100 deletions(-)
>> delete mode 100644 arch/arm/mach-msm/headsmp.S
> Don't you need to update arch/arm/mach-msm/Makefile to remove headsmp.o from:
>
> obj-$(CONFIG_SMP) += headsmp.o platsmp.o

Will do
> - k
>
> --
> Employee of Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation


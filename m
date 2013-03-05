Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040Ab3CECzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 21:55:05 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60896 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3CECzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 21:55:03 -0500
X-IronPort-AV: E=Sophos;i="4.84,784,1355126400"; 
   d="scan'208";a="27461884"
Message-ID: <51355E85.7010804@codeaurora.org>
Date: Mon, 04 Mar 2013 18:55:01 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: perf: Fix section mismatch on armpmu_init()
References: <1362438937-28143-1-git-send-email-sboyd@codeaurora.org> <20130305024338.GA17735@mudshark.cambridge.arm.com>
In-Reply-To: <20130305024338.GA17735@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/13 18:43, Will Deacon wrote:
> On Mon, Mar 04, 2013 at 11:15:37PM +0000, Stephen Boyd wrote:
>> WARNING: vmlinux.o(.text+0xfb80): Section mismatch in reference
>> from the function armpmu_register() to the function
>> .init.text:armpmu_init()
>> The function armpmu_register() references
>> the function __init armpmu_init().
>> This is often because armpmu_register lacks a __init
>> annotation or the annotation of armpmu_init is wrong.
>>
>> Just drop the __init marking on armpmu_init() because
>> armpmu_register() no longer has an __init marking.
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cheers Stephen:
>
>   Acked-by: Will Deacon <will.deacon@arm.com>
>
> Can you put this into the patch system please?
>
>

Thanks.  7667/1

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


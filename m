Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab3ILQfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:35:01 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54239 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab3ILQe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:34:59 -0400
Message-ID: <5231ED31.7080102@codeaurora.org>
Date: Thu, 12 Sep 2013 09:34:57 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: David Brown <davidb@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-arm-msm@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: msm: Add support for MSM8974 Dragonboard
References: <1375743779-24993-1-git-send-email-rvaswani@codeaurora.org>  <1375780486.2725.7.camel@iivanov-dev.int.mm-sol.com>  <20130911180006.GA12624@codeaurora.org> <1378994706.16481.6.camel@iivanov-dev.int.mm-sol.com>
In-Reply-To: <1378994706.16481.6.camel@iivanov-dev.int.mm-sol.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/2013 7:05 AM, Ivan T. Ivanov wrote:
> Hi,
>
> On Wed, 2013-09-11 at 11:00 -0700, David Brown wrote:
>> On Tue, Aug 06, 2013 at 12:14:46PM +0300, Ivan T. Ivanov wrote:
>>
>>> Attached patch enables earlyprink for this board.
>>>
>>> [920] booting linux @ 0x8000, ramdisk @ 0x2000000 (1067699), tags/device tree @ 0x1e00000
>>> Uncompressing Linux... done, booting the kernel.
>>> [    0.000000] Booting Linux on physical CPU 0x0
>>> [    0.000000] Linux version 3.11.0-rc4-00003-g7c8394e (iivanov@dev) (gcc version 4.6.3 (GCC) ) #502 SMP PREEMPT Tue Aug 6 12:09:07 EEST3
>>> [    0.000000] CPU: ARMv7 Processor [512f06f0] revision 0 (ARMv7), cr=10c5387d
>>> [    0.000000] CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
>>> [    0.000000] Machine: Qualcomm MSM (Flattened Device Tree), model: Qualcomm MSM8974 Dragonboard
>> We'll need to have either Rohit include this in his patch series, or
>> you'll have to format this as a valid patch.
> I don't have preferences. Rohit could you send this patch
> with you changes?

Yep. Will fixup this as part of the initial support.
> Regards,
> Ivan
>
>> Thanks,
>> David
>>
>


Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation


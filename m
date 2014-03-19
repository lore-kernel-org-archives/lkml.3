Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbaCSRUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:20:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33938 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaCSRUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:20:17 -0400
Message-ID: <5329D037.4030008@wwwdotorg.org>
Date: Wed, 19 Mar 2014 11:13:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Mark Brown <broonie@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Vince Hsu <vinceh@nvidia.com>
Subject: Re: [PATCH] mfd: as3722: make FUSE7_REG readable
References: <1393951832-2638-1-git-send-email-swarren@wwwdotorg.org> <20140305015539.GK10579@lee--X1> <5329C133.60900@wwwdotorg.org> <20140319170138.GK31687@lee--X1> <20140319170437.GA18095@lee--X1>
In-Reply-To: <20140319170437.GA18095@lee--X1>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 11:04 AM, Lee Jones wrote:
>>>>> From: Stephen Warren <swarren@nvidia.com>
>>>>>
>>>>> The FUSE7_REG register is not currently marked readable. This causes
>>>>> as3722_sd0_is_low_voltage() to emit an error during boot, and assume
>>>>> the range of the SD0 regulator:
>>>>>
>>>>> as3722-regulator as3722-regulator: Reg 0xa7 read failed: -5
...
>>>> Applied to MFD -next (v3.15).
>>>
>>> I don't see this in next-20140319; did it get dropped somewhere, or was
>>> your branch not pushed out?
>>
>> Ah, thanks for the reminder.
>>
>> I moved the MFD tree from linaro.org to kernel.org, but failed to let
>> Stephen know. I'll do so now.
> 
> Whoops. No, you're Stephen. I meant Andrew.

I think you did mean Stephen (Rothwell) :-)

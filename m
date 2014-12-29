Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaL2OQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:16:00 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:34336 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaL2OP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:15:57 -0500
Message-ID: <54A16217.1060006@codeaurora.org>
Date: Mon, 29 Dec 2014 16:15:51 +0200
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: hujianyang <hujianyang@huawei.com>
CC: dedekind1@gmail.com, linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH V6] UBI: Extend UBI layer debug/messaging capabilities
References: <1415023112-21704-1-git-send-email-tlinder@codeaurora.org> <54A0C70D.7040706@huawei.com>
In-Reply-To: <54A0C70D.7040706@huawei.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hu,

On 12/29/2014 5:14 AM, hujianyang wrote:
> On 2014/11/3 21:58, Tanya Brokhman wrote:
>> If there is more then one UBI device mounted, there is no way to
>> distinguish between messages from different UBI devices.
>> Add device number to all ubi layer message types.
>>
>> The R/O block driver messages were replaced by pr_* since
>> ubi_device structure is not used by it.
>>
>> Amended a bit by Artem.
>>
>> Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
>> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>> ---
>> Changes from V1:
>
>
> Hi Artem and Tanya,
>
> Do you think the similar effort is worth to be done on ubifs-level?

We already did this for UBIFS as well and have been working with this 
patch for some time now. Its in our todo to share it, just got pulled 
into some urgent staff unfortunately.


Thanks,
Tanya Brokhman
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum, a Linux Foundation Collaborative Project

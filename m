Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaKGMcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:32:46 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54613 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaKGMcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:32:43 -0500
Message-ID: <545CBBE2.7000205@codeaurora.org>
Date: Fri, 07 Nov 2014 14:32:34 +0200
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: hujianyang <hujianyang@huawei.com>, dedekind1@gmail.com
CC: linux-arm-msm@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, Richard Weinberger <richard@nod.at>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH V6] UBI: Extend UBI layer debug/messaging capabilities
References: <1415023112-21704-1-git-send-email-tlinder@codeaurora.org> <1415201733.958.121.camel@sauron.fi.intel.com> <545C9A1B.6020905@huawei.com>
In-Reply-To: <545C9A1B.6020905@huawei.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/7/2014 12:08 PM, hujianyang wrote:
> On 2014/11/5 23:35, Artem Bityutskiy wrote:
>> On Mon, 2014-11-03 at 15:58 +0200, Tanya Brokhman wrote:
>>> If there is more then one UBI device mounted, there is no way to
>>> distinguish between messages from different UBI devices.
>>> Add device number to all ubi layer message types.
>>>
>>> The R/O block driver messages were replaced by pr_* since
>>> ubi_device structure is not used by it.
>>>
>>> Amended a bit by Artem.
>>>
>>> Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
>>> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>>
>> Oh, the entire patch-set again... this means we need to review it again!
>> Please, have a mercy! :-) It is huge! Please, send a small patch against
>> the one which I pushed already. Thanks!
>>

Oh :( and I did that on purpose.... For some reason I thought you would 
revert that one and push a new and updated one.
Ok, I'll upload a short version.

>
> That means I can't add a Reviewed-by on this huge one...

... and then you can add Reviewed-by! :)
>
> What a pity~! ^.^
>
>
>> Artem.
>>
>>
>> ______________________________________________________
>> Linux MTD discussion mailing list
>> http://lists.infradead.org/mailman/listinfo/linux-mtd/
>>
>>
>
>


Thanks,
Tanya Brokhman
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

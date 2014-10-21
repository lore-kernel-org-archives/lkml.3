Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbaJUIwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:52:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42229 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaJUIws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:52:48 -0400
Message-ID: <54461EDB.6020100@codeaurora.org>
Date: Tue, 21 Oct 2014 11:52:43 +0300
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: ezequiel.garcia@free-electrons.com, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V5] mtd: ubi: Extend UBI layer debug/messaging capabilities
References: <1413824221-31235-1-git-send-email-tlinder@codeaurora.org> <1413878186.7906.405.camel@sauron.fi.intel.com>
In-Reply-To: <1413878186.7906.405.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 10:56 AM, Artem Bityutskiy wrote:
> On Mon, 2014-10-20 at 19:57 +0300, Tanya Brokhman wrote:
>> If there is more then one UBI device mounted, there is no way to
>> distinguish between messages from different UBI devices.
>> Add device number to all ubi layer message types.
>>
>> The R/O block driver messages were replaced by pr_* since
>> ubi_device structure is not used by it.
>>
>> Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
>
> Pushed to linux-ubifs.git, thanks.
>
> You did not get indentations right, though, so I amended your patch.
> Also, some lines were split unnecessarily. My amendments are in the diff
> below. Please, take this into account for the similar UBIFS patch which
> you was going to send. Thank you!

Thanks Artem and sorry for the extra work for you. I was trying to find 
the balance between pleasing checkpatch and your request to have the 
message in the same line :)
Will be extra careful about the indentation next time (guess my editor 
needs re-configuration). Sorry about that.


Thanks,
Tanya Brokhman
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum, a Linux Foundation Collaborative Project

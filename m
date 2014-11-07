Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbaKGKJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 05:09:51 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:5858 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaKGKJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 05:09:49 -0500
Message-ID: <545C9A1B.6020905@huawei.com>
Date: Fri, 7 Nov 2014 18:08:27 +0800
From: hujianyang <hujianyang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: Tanya Brokhman <tlinder@codeaurora.org>, <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, Richard Weinberger <richard@nod.at>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH V6] UBI: Extend UBI layer debug/messaging capabilities
References: <1415023112-21704-1-git-send-email-tlinder@codeaurora.org> <1415201733.958.121.camel@sauron.fi.intel.com>
In-Reply-To: <1415201733.958.121.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.144]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/5 23:35, Artem Bityutskiy wrote:
> On Mon, 2014-11-03 at 15:58 +0200, Tanya Brokhman wrote:
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
> 
> Oh, the entire patch-set again... this means we need to review it again!
> Please, have a mercy! :-) It is huge! Please, send a small patch against
> the one which I pushed already. Thanks!
>

That means I can't add a Reviewed-by on this huge one...

What a pity~! ^.^


> Artem.
> 
> 
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
> 
> 



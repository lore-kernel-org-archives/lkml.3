Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaL3B3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 20:29:30 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:4466 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaL3B33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 20:29:29 -0500
Message-ID: <54A1FF8D.4010301@huawei.com>
Date: Tue, 30 Dec 2014 09:27:41 +0800
From: hujianyang <hujianyang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>
CC: <dedekind1@gmail.com>, <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>, <linux-mtd@lists.infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH V6] UBI: Extend UBI layer debug/messaging capabilities
References: <1415023112-21704-1-git-send-email-tlinder@codeaurora.org> <54A0C70D.7040706@huawei.com> <54A16217.1060006@codeaurora.org>
In-Reply-To: <54A16217.1060006@codeaurora.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.144]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.54A1FFAF.0147,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 9502020e319fc52adc9adc6a5411b3d3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/29 22:15, Tanya Brokhman wrote:
> Hi Hu,
> 
> On 12/29/2014 5:14 AM, hujianyang wrote:
>> On 2014/11/3 21:58, Tanya Brokhman wrote:
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
>>> ---
>>> Changes from V1:
>>
>>
>> Hi Artem and Tanya,
>>
>> Do you think the similar effort is worth to be done on ubifs-level?
> 
> We already did this for UBIFS as well and have been working with this patch for some time now. Its in our todo to share it, just got pulled into some urgent staff unfortunately.
> 

Got it~!

I'd like to wait for your patch, thanks for your work.

Hu

> 
> Thanks,
> Tanya Brokhman



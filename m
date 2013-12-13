Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab3LMGYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 01:24:19 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:65043 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab3LMGYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 01:24:12 -0500
X-AuditID: cbfec7f5-b7f6f6d000005b3b-67-52aaa809ef35
Message-id: <52AAA806.30406@samsung.com>
Date: Fri, 13 Dec 2013 07:24:06 +0100
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330
 Thunderbird/17.0.5
MIME-version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>, linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Ingo Molnar'" <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] kernel/locking: mutex: simplify access to the first
 entry in the wait-list
References: <1386847772-8918-1-git-send-email-andrzej.p@samsung.com>
 <20131212113511.GG21999@twins.programming.kicks-ass.net>
 <23bd01cef731$fb052680$f10f7380$%park@samsung.com>
 <20131212125203.GI21999@twins.programming.kicks-ass.net>
In-reply-to: <20131212125203.GI21999@twins.programming.kicks-ass.net>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t/xK7qcK1YFGfQs47RoXryezeJs0xt2
	i8u75rBZrD1yl93i0oEFTBbHew8wObB5bF6h5bF/7hp2j/f7rrJ59G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8bs04+ZCn5wV1yeuIC1gfEBZxcjJ4eEgInEiks7mCBsMYkL99azdTFycQgJ
	LGWUmPrzOxOE85lR4uCNLWBVvAIaEmcOv2YDsVkEVCXmP9jBDGKzCRhL7D3YwQhiiwqESUx9
	e4cNol5Q4sfkeywgtoiApsTKtvtgG5gFLjNKrO97BjZUWCBF4se16awQ294zSixv2sIKkuAU
	cJVYtOcXmM0sYC2xctI2RghbXmLzmrfMExgFZiFZMgtJ2SwkZQsYmVcxiqaWJhcUJ6XnGukV
	J+YWl+al6yXn525ihIT31x2MS49ZHWIU4GBU4uH16F0VJMSaWFZcmXuIUYKDWUmEd786UIg3
	JbGyKrUoP76oNCe1+BAjEwenVANjxmv7HZe4Lto4OcU63r7tOSW/4XTVo+np85aqX5qVJxva
	Fvylyv6L6MW+9r69gpPm7pT4EOefY6HUPp/v1gXZXdsaXm0+4jtNSOmDV9DhcwlGMwL/1LHa
	6xi/ifgUrPn18hS7SbIXnvlc5V7IJ8zPUXO2fKWEq9eTXzLTIjcunLe46DGjzJcdSizFGYmG
	WsxFxYkAHKyQuU0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo & Peter,

I added Greg on Cc.

W dniu 12.12.2013 13:52, Peter Zijlstra pisze:
> On Thu, Dec 12, 2013 at 09:02:07PM +0900, Kyungmin Park wrote:
>>
>>> -----Original Message-----
>>> From: Peter Zijlstra [mailto:peterz@infradead.org]
>>> Sent: Thursday, December 12, 2013 8:35 PM
>>> To: Andrzej Pietrasiewicz
>>> Cc: linux-kernel@vger.kernel.org; Kyungmin Park; Marek Szyprowski; Ingo
>>> Molnar
>>> Subject: Re: [PATCH v2] kernel/locking: mutex: simplify access to the
>>> first entry in the wait-list
>>>
>>> On Thu, Dec 12, 2013 at 12:29:32PM +0100, Andrzej Pietrasiewicz wrote:
>>>> Use list_first_entry instead of explicitly accessing the first entry
>>>> with "head".next. The comment one line above becomes obsolete.
>>>>
>>>> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> ---

For quite a long time I've been sending the same SOB lines to the
linux-usb list.

Can you please refer here:

http://www.spinics.net/lists/linux-usb/msg74981.html


>>>>
>>>> v1..v2:
>>>>
>>>> - corrected the email address in the second Signed-off-by line
>>>
>>> Still invalid; the problem is that you appear to have written the patch
>>> (you send it and you have first sob).
>>
>>
>>> So what is Kyungmin doing in the line? He did not send me your patch.
>>
>> Internal review process, and it represents this patch comes from.
>
> For review we have this specific tag, oddly called: 'Reviewed-by'.
>

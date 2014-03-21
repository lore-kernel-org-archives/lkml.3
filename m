Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbaCUP7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:59:07 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:50375 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758706AbaCUP7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:59:03 -0400
Message-ID: <532C631C.5070105@gmail.com>
Date: Fri, 21 Mar 2014 17:04:44 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Mike Turquette <mturquette@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Subject: Re: [PATCH 1/5] clk: berlin: add support for berlin plls
References: <1395402220-23503-1-git-send-email-alexandre.belloni@free-electrons.com> <1395402220-23503-2-git-send-email-alexandre.belloni@free-electrons.com> <532C355C.3090606@gmail.com> <20140321155633.GF6443@piout.net>
In-Reply-To: <20140321155633.GF6443@piout.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 04:56 PM, Alexandre Belloni wrote:
> On 21/03/2014 at 13:49:32 +0100, Sebastian Hesselbarth wrote :
>> On 03/21/2014 12:43 PM, Alexandre Belloni wrote:
>>> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
>>> index a367a9831717..4a2602737c27 100644
>>> --- a/drivers/clk/Makefile
>>> +++ b/drivers/clk/Makefile
>>> @@ -29,6 +29,7 @@ obj-$(CONFIG_ARCH_VT8500)		+= clk-vt8500.o
>>>   obj-$(CONFIG_COMMON_CLK_WM831X)		+= clk-wm831x.o
>>>   obj-$(CONFIG_COMMON_CLK_XGENE)		+= clk-xgene.o
>>>   obj-$(CONFIG_COMMON_CLK_AT91)		+= at91/
>>> +obj-$(CONFIG_ARCH_BERLIN)		+= berlin/
>>>   obj-$(CONFIG_ARCH_HI3xxx)		+= hisilicon/
>>>   obj-$(CONFIG_COMMON_CLK_KEYSTONE)	+= keystone/
>>
>> I'll have a look at clk/Makefile later myself, but alphabetic ordering
>> seems to be broken by ARCH_HI3xxx already. Anyway, we shouldn't just
>> add another violator.
>>
>
> BTW,  don't think there is any issue here, the Makefile states:
> # please keep this section sorted lexicographically by file/directory path name

Ok, thanks for the clarification. As I said, I should have
looked it up myself in the first place.

Sebastian


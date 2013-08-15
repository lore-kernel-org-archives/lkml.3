Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab3HOIdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 04:33:00 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:37717 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab3HOIc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 04:32:56 -0400
Message-ID: <520C9235.5070104@gmail.com>
Date: Thu, 15 Aug 2013 01:32:53 -0700
From: Brian Norris <computersforpeace@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Caizhiyong <caizhiyong@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Karel Zak <kzak@redhat.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@huawei.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Huang Shijie <b32955@freescale.com>
Subject: Re: [PATCH] block: add command line partition parser
References: <C3050A4DBA34F345975765E43127F10F1C061D75@szxeml512-mbs.china.huawei.com> <20130805152206.76462cc4a42e51b16a0532f1@linux-foundation.org> <C3050A4DBA34F345975765E43127F10F1C06237C@szxeml512-mbs.china.huawei.com> <20130814155742.d3cd651e40e552696667e4f2@linux-foundation.org> <CAN8TOE-aGcKQNayzEVQaS1wJ_Uqp3RAZ5pTuVEhaaY9f487-xA@mail.gmail.com> <C3050A4DBA34F345975765E43127F10F1C063B36@szxeml512-mbx.china.huawei.com> <20130815050007.GA23474@brian-ubuntu> <C3050A4DBA34F345975765E43127F10F1C064357@szxeml512-mbx.china.huawei.com> <20130815070938.GB24007@brian-ubuntu> <C3050A4DBA34F345975765E43127F10F1C064375@szxeml512-mbx.china.huawei.com>
In-Reply-To: <C3050A4DBA34F345975765E43127F10F1C064375@szxeml512-mbx.china.huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2013 12:45 AM, Caizhiyong wrote:
>> -----Original Message-----
>> From: Brian Norris [mailto:computersforpeace@gmail.com]
...
>> On Thu, Aug 15, 2013 at 06:16:04AM +0000, Caizhiyong wrote:
>>> I want to use the MTD command line partition method on block devices (eMMC).
>>> It is very suitable for embedded systems. I think, in embedded system partition
>> method,
>>> if somebody need some feature on MTD device, he may be also need it on block device.
>>> so I fully functional reference MTD command line partition.
>>
>> I agree.
>>
>> I'm curious: have you seen any need for a similar arrangement via
>> device-tree? See, for example, drivers/mtd/ofpart.c.
>
> So far, I have no seen. We mainly use ARM. For ARM, device-tree is a new thing.

But device-tree is *the* thing for ARM going forward, and the kernel 
command line can get unwieldy (and beyond its limits) pretty quickly 
like this.

>>> I hope extend the flexibility to block device.
>>
>> Sure. I'll try to review the full patch soon and test out integrating
>> it with MTD.
>
> If there is no problem, I will send my next patch, mtd cmdline parts use cmdline-parser lib.

We will get some reviews on this soon (no time for me tonight). Do you 
already have a mtd patch? If so, you might as well post it for review as 
well.

Thanks,
Brian

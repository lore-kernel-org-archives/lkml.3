Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaEVArQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 20:47:16 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:42326 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaEVArO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 20:47:14 -0400
Message-ID: <537D490D.9080602@gmail.com>
Date: Thu, 22 May 2014 08:47:09 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Subject: Re: =?UTF-8?B?5Zue5aSN77yaIFJlOiDlm57lpI3vvJogUmU6IOWbnuWkje+8miA=?=
 =?UTF-8?B?UmU6IOWbnuWkje+8miBbUEFUQ0hdIGFyY2gvdW5pY29yZTMyL2tlcm5lbC9zZXQ=?=
 =?UTF-8?B?dXAuYzogYWRkIGdlbmVyaWMgJ3NjcmVlbl9pbmZvJyB0byBhdm9pZCBjb21waWw=?=
 =?UTF-8?B?aW5nIGZhaWx1cmU=?=
References: <750179772.46188.1400718712110.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <750179772.46188.1400718712110.JavaMail.root@bj-mail03.pku.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/22/2014 08:31 AM, 管雪涛 wrote:
> 
> ----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
>> On 05/22/2014 07:59 AM, 管雪涛 wrote:
>>> ----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
>>>>>>  - the other for additional 'clk_*' which are needed when HAVE_CLK.
>>>>>>    I guess, just "copy/past" the other platforms' implementation is OK.
>>>>>
>>>>> Maybe, COMMON_CLK should be selected. I'm not sure.
>>>>>
>>>>
>>>> I guess so, if you have already fix it (maybe you have done, I am not
>>>> quite familiar with version merging of Linux kernel), please let me
>>>> know. Or I shall process (continue think of) it within this month.
>>>
>>> Ok, I'll arrange this work, but maybe finish it in next month.
>>>
>>
>> Thanks, it is OK to me.
>>
>> And for this last issue of unicore32 allmodconfig, it needs COMMON_CLK,
>> but after add it, it will generate a conflict between "arch/unicore32
>> /kernel/clock.c" and "drivers/clk/clk.c".
> 
> Yes, they implement similar functions, and I need use the latter to reimplement the former.
> 

OK, thanks. Hope it is really the last failure issue for allmodconfig
under unicore32.

>>
>> I guess it needs more thinking of about architecture related features,
>> I am not quite sure about it, so please help fix it, when you have
>> time, thanks.
>>
>> The related error:
>>
>>     LD      vmlinux.o
>>   drivers/built-in.o: In function `clk_unregister':
>>   powercap_sys.c:(.text+0xa96d0): multiple definition of `clk_unregister'
[...]

Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed

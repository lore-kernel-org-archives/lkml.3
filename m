Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaEUJbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:31:12 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:57177 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaEUJbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:31:10 -0400
Message-ID: <537C7258.2010304@gmail.com>
Date: Wed, 21 May 2014 17:31:04 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Subject: Re: =?UTF-8?B?5Zue5aSN77yaIFJlOiDlm57lpI3vvJogW1BBVENIXSBhcmNoL3U=?=
 =?UTF-8?B?bmljb3JlMzIva2VybmVsL3NldHVwLmM6IGFkZCBnZW5lcmljICdzY3JlZW5faW4=?=
 =?UTF-8?B?Zm8nIHRvIGF2b2lkIGNvbXBpbGluZyBmYWlsdXJl?=
References: <1381816856.42144.1400664218906.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <1381816856.42144.1400664218906.JavaMail.root@bj-mail03.pku.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/21/2014 05:23 PM, 管雪涛 wrote:
> 
> ----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
>>
>> Yeah, I shall send patch v2 for it (within this week). And also thank
>> you for your review the other patches.
>>
>> BTW: I guess, it only leaves 2 kernel related issues for allmodconfig:
>>
>>  - one for 'find_first*', 'cpuc_coherent_kern_range' and 'pm_power_off'.
>>    I guess, we can export their symbol explicitly to fix this issue.
> 
> My suggestion:
>  find_first_* could export themselves in lib/find_first.c, so each archs can use it.
>    anyway, we can first add them in unicore32, and then make it a generic lib.
>  what's the problem with cpuc_coherent_kern_range? in fact, I'll remove it later.
>  pm_power_off need be exported.
> 

Thank you for your suggestions, and if you have already fixed them
(maybe you have done), please let me know. Or I shall send them within
this month.

The related error for 'cpu_coherent_kern_rage':

  ERROR: "__cpuc_coherent_kern_range" [drivers/misc/lkdtm.ko] undefined!

>>
>>  - the other for additional 'clk_*' which are needed when HAVE_CLK.
>>    I guess, just "copy/past" the other platforms' implementation is OK.
> 
> Maybe, COMMON_CLK should be selected. I'm not sure.
> 

I guess so, if you have already fix it (maybe you have done, I am not
quite familiar with version merging of Linux kernel), please let me
know. Or I shall process (continue think of) it within this month.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed

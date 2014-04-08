Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177AbaDHNL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:11:27 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:60944 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136AbaDHNLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:11:22 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s38DAcF5023224, This message is accepted by code: ctloc85258
Message-ID: <5343F535.5070408@realtek.com>
Date: Tue, 8 Apr 2014 21:10:13 +0800
From: Roger <rogerable@realtek.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <driverdev-devel@linuxdriverproject.org>,
        <wei_wang@realsil.com.cn>, <micky_ching@realsil.com.cn>
Subject: Re: [PATCH v5 3/3] memstick: Add realtek USB memstick host driver
References: <1395744293-24398-1-git-send-email-rogerable@realtek.com> <1395744293-24398-4-git-send-email-rogerable@realtek.com> <533A3080.2020008@realtek.com> <20140401150654.fe27636428a62fdf9e0d2dc1@linux-foundation.org> <20140402151654.GA24060@lee--X1> <5343ADFA.7010703@realtek.com> <20140408113751.GG8888@lee--X1>
In-Reply-To: <20140408113751.GG8888@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 07:37 PM, Lee Jones wrote:
>>>
>> Lee,
>>
>> When I prepare my next submission, I found a previous version of
>> this patch set(and only the 1/3 'mfd' part)  seems to be merged in
>> the following commit:
>>
>> commit e5744abb2fa3629aa5a94e21ca1eae32ff2fe00b
>> Merge: c29aa15 2d28ca7
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Mon Apr 7 10:24:18 2014 -0700
>>
>>      Merge tag 'mfd-for-linus-3.15' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd
>>
>> Is there any chance to revert it? Or what can I do to help current
>> situation?
>
> What will happen if we don't revert it? Does it depend on something
> else?
>
No, it has no dependency error but only provides an unused mfd device 
and exports nothing functional to user.

I think it would be good to submit the diff between the merged 1/3 patch 
and the v6, along with full 2/3 and 3/3.

>> note: the merged commit:
>> commit 730876be256603b4ee7225a125467d97a7ce9060
>> Author: Roger Tseng <rogerable@realtek.com>
>> Date:   Wed Feb 12 18:00:36 2014 +0800
>>
>>      mfd: Add realtek USB card reader driver
>>
>>
>> Best regards,
>> Roger Tseng
>

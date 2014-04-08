Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbaDHIHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 04:07:23 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:46829 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242AbaDHIHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:07:19 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s3886deS029804, This message is accepted by code: ctloc85258
Message-ID: <5343ADFA.7010703@realtek.com>
Date: Tue, 8 Apr 2014 16:06:18 +0800
From: Roger <rogerable@realtek.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <driverdev-devel@linuxdriverproject.org>,
        <wei_wang@realsil.com.cn>, <micky_ching@realsil.com.cn>
Subject: Re: [PATCH v5 3/3] memstick: Add realtek USB memstick host driver
References: <1395744293-24398-1-git-send-email-rogerable@realtek.com> <1395744293-24398-4-git-send-email-rogerable@realtek.com> <533A3080.2020008@realtek.com> <20140401150654.fe27636428a62fdf9e0d2dc1@linux-foundation.org> <20140402151654.GA24060@lee--X1>
In-Reply-To: <20140402151654.GA24060@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/02/2014 11:16 PM, Lee Jones wrote:
> On Tue, 01 Apr 2014, Andrew Morton wrote:
>
>> On Tue, 1 Apr 2014 11:20:32 +0800 Roger <rogerable@realtek.com> wrote:
>>
>>> On 03/25/2014 06:44 PM, rogerable@realtek.com wrote:
>>>> From: Roger Tseng <rogerable@realtek.com>
>>>>
>>>> Realtek USB memstick host driver provides memstick host support based on the
>>>> Realtek USB card reader MFD driver.
>>>>
>>>> Signed-off-by: Roger Tseng <rogerable@realtek.com>
>>>> ---
>>>>    drivers/memstick/host/Kconfig       |  10 +
>>>>    drivers/memstick/host/Makefile      |   1 +
>>>>    drivers/memstick/host/rtsx_usb_ms.c | 839 ++++++++++++++++++++++++++++++++++++
>>>>    3 files changed, 850 insertions(+)
>>>>    create mode 100644 drivers/memstick/host/rtsx_usb_ms.c
>>> Hi Andrew,
>>>
>>> Since I'll have to send next revision(v6, to modify patch 1/3) and
>>> you've commented v4, would you also comment or Ack the 3/3 of this one?
>>> This should save one revision for me to make any necessary change.
>>
>> It looks OK to my inexpert eye.  It would be better if Maxim and/or Alex
>> could review the code.  If that doesn't happen then I guess the best we
>> can do is to go ahead and merge it.  Have you worked out via which tree
>> the patches will be merged?
>
> I'll be happy to take the set if one of the subsystem experts would be
> kind enough to cast an eye over it.
>
> Maxim, Alex?
>
Lee,

When I prepare my next submission, I found a previous version of this 
patch set(and only the 1/3 'mfd' part)  seems to be merged in the 
following commit:

commit e5744abb2fa3629aa5a94e21ca1eae32ff2fe00b
Merge: c29aa15 2d28ca7
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Apr 7 10:24:18 2014 -0700

     Merge tag 'mfd-for-linus-3.15' of 
git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd

Is there any chance to revert it? Or what can I do to help current 
situation?

note: the merged commit:
commit 730876be256603b4ee7225a125467d97a7ce9060
Author: Roger Tseng <rogerable@realtek.com>
Date:   Wed Feb 12 18:00:36 2014 +0800

     mfd: Add realtek USB card reader driver


Best regards,
Roger Tseng

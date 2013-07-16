Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299Ab3GPQLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:11:16 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:47242 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab3GPQLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:11:14 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <51E53811.6040100@metafoo.de>
References: <1373898160-8460-1-git-send-email-otavio@ossystems.com.br> <1373898160-8460-5-git-send-email-otavio@ossystems.com.br> <51E5195B.3020908@kernel.org> <51E51FBE.6000205@metafoo.de> <CAP9ODKrsQqa12ZVj0R+rpb=kjtb-63P7yraVmV0+yZxaaeMcsQ@mail.gmail.com> <51E53811.6040100@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 5/5] iio: add configuration option for debug support
From: Jonathan Cameron <jic23@kernel.org>
Date: Tue, 16 Jul 2013 17:11:07 +0100
To: Lars-Peter Clausen <lars@metafoo.de>,
        Otavio Salvador <otavio@ossystems.com.br>
CC: Kernel development list <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org
Message-ID: <07271c08-5b24-4d86-8833-4ff2e15c8bed@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Lars-Peter Clausen <lars@metafoo.de> wrote:
>On 07/16/2013 02:01 PM, Otavio Salvador wrote:
>> On Tue, Jul 16, 2013 at 7:26 AM, Lars-Peter Clausen <lars@metafoo.de>
>wrote:
>>> On 07/16/2013 11:58 AM, Jonathan Cameron wrote:
>>>> On 07/15/2013 03:22 PM, Otavio Salvador wrote:
>>>>> Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
>>>> seems a sensible facility to have available.
>>>>
>>>> Applied to the togreg branch of iio.git
>>>
>>> Can you update the Kconfig help text?
>> 
>> Sure I can. Jonathan seem to have applied it so should I send a v2 or
>> a new patch?
>> 
>
>He hasn't pushed things out yet, I think a v2 will be fine.
>

Yup a v2 is fine.  Actually I regularly rebase this tree and it may eat babies! All work more or less should be against Greg's staging/staging-next tree as that is nice and non debasing.
>>>>> ---
>>>>>  drivers/iio/Kconfig  | 7 +++++++
>>>>>  drivers/iio/Makefile | 2 ++
>>>>>  2 files changed, 9 insertions(+)
>>>>>
>>>>> diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
>>>>> index 9af763a..d1f06f2 100644
>>>>> --- a/drivers/iio/Kconfig
>>>>> +++ b/drivers/iio/Kconfig
>>>>> @@ -12,6 +12,13 @@ menuconfig IIO
>>>>>
>>>>>  if IIO
>>>>>
>>>>> +config IIO_DEBUG
>>>>> +    boolean "Debug support for Industrial I/O"
>>>>> +    depends on DEBUG_KERNEL
>>>>> +    help
>>>>> +      Say "yes" to enable debug messaging (like dev_dbg and
>pr_debug),
>>>>> +      sysfs, and debugfs support in Industrial I/O subsystem and
>drivers.
>>>
>>> This has nothing to do with either sysfs or debugfs support.
>> 
>>      Say "yes" to enable debug messaging (like dev_dbg and pr_debug)
>>      support in Industrial I/O subsystem and drivers.
>> 
>> ?
>> 
>> --
>> Otavio Salvador                             O.S. Systems
>> http://www.ossystems.com.br        http://projetos.ossystems.com.br
>> Mobile: +55 (53) 9981-7854            Mobile: +1 (347) 903-9750
>> 
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.

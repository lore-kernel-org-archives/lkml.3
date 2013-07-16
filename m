Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab3GPMBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:01:50 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:44200 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab3GPMBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:01:49 -0400
MIME-Version: 1.0
In-Reply-To: <51E51FBE.6000205@metafoo.de>
References: <1373898160-8460-1-git-send-email-otavio@ossystems.com.br>
	<1373898160-8460-5-git-send-email-otavio@ossystems.com.br>
	<51E5195B.3020908@kernel.org>
	<51E51FBE.6000205@metafoo.de>
Date: Tue, 16 Jul 2013 09:01:48 -0300
X-Google-Sender-Auth: KE959CQb-eN2nMX2RHEyet20R9s
Message-ID: <CAP9ODKrsQqa12ZVj0R+rpb=kjtb-63P7yraVmV0+yZxaaeMcsQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] iio: add configuration option for debug support
From: Otavio Salvador <otavio@ossystems.com.br>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 7:26 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 07/16/2013 11:58 AM, Jonathan Cameron wrote:
>> On 07/15/2013 03:22 PM, Otavio Salvador wrote:
>>> Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
>> seems a sensible facility to have available.
>>
>> Applied to the togreg branch of iio.git
>
> Can you update the Kconfig help text?

Sure I can. Jonathan seem to have applied it so should I send a v2 or
a new patch?

>>> ---
>>>  drivers/iio/Kconfig  | 7 +++++++
>>>  drivers/iio/Makefile | 2 ++
>>>  2 files changed, 9 insertions(+)
>>>
>>> diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
>>> index 9af763a..d1f06f2 100644
>>> --- a/drivers/iio/Kconfig
>>> +++ b/drivers/iio/Kconfig
>>> @@ -12,6 +12,13 @@ menuconfig IIO
>>>
>>>  if IIO
>>>
>>> +config IIO_DEBUG
>>> +    boolean "Debug support for Industrial I/O"
>>> +    depends on DEBUG_KERNEL
>>> +    help
>>> +      Say "yes" to enable debug messaging (like dev_dbg and pr_debug),
>>> +      sysfs, and debugfs support in Industrial I/O subsystem and drivers.
>
> This has nothing to do with either sysfs or debugfs support.

     Say "yes" to enable debug messaging (like dev_dbg and pr_debug)
     support in Industrial I/O subsystem and drivers.

?

--
Otavio Salvador                             O.S. Systems
http://www.ossystems.com.br        http://projetos.ossystems.com.br
Mobile: +55 (53) 9981-7854            Mobile: +1 (347) 903-9750

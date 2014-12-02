Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952AbaLBHuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:50:21 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46458 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbaLBHuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:50:18 -0500
MIME-Version: 1.0
In-Reply-To: <547D6B07.6050803@xs4all.nl>
References: <1416791411-9731-1-git-send-email-prabhakar.csengg@gmail.com>
 <547C3ED3.1060205@xs4all.nl> <547C4A69.8020002@xs4all.nl> <CA+V-a8uL4J0Y2ZfDxe7jhxzGcCNe9QbCDUjDZrC+mZ5E6sX2jg@mail.gmail.com>
 <547D6B07.6050803@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 2 Dec 2014 07:49:45 +0000
Message-ID: <CA+V-a8vsXSG=bqYcsh+Ud3J9Ha7o5AL15N+seMpUPYggqXZRKQ@mail.gmail.com>
Subject: Re: [PATCH] media: platform: add VPFE capture driver support for AM437X
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-api <linux-api@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Tue, Dec 2, 2014 at 7:32 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 12/01/2014 11:27 PM, Prabhakar Lad wrote:
>> Hi Hans,
>>
>> On Mon, Dec 1, 2014 at 11:00 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> On 12/01/2014 11:11 AM, Hans Verkuil wrote:
>>>> Hi all,
>>>>
>>>> Thanks for the patch, review comments are below.
>>>>
>>>> For the next version I would appreciate if someone can test this driver with
>>>> the latest v4l2-compliance from the v4l-utils git repo. If possible test streaming
>>>> as well (v4l2-compliance -s), ideally with both a sensor and a STD receiver input.
>>>> But that depends on the available hardware of course.
>>>>
>>>> I'd like to see the v4l2-compliance output. It's always good to have that on
>>>> record.
>>>>
>>>>
>>>> On 11/24/2014 02:10 AM, Lad, Prabhakar wrote:
>>>>> From: Benoit Parrot <bparrot@ti.com>
>>>>>
>>>>> This patch adds Video Processing Front End (VPFE) driver for
>>>>> AM437X family of devices
>>>>> Driver supports the following:
>>>>> - V4L2 API using MMAP buffer access based on videobuf2 api
>>>>> - Asynchronous sensor/decoder sub device registration
>>>>> - DT support
>>>>>
>>>>> Signed-off-by: Benoit Parrot <bparrot@ti.com>
>>>>> Signed-off-by: Darren Etheridge <detheridge@ti.com>
>>>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>>> ---
>>>>>  .../devicetree/bindings/media/ti-am437xx-vpfe.txt  |   61 +
>>>>>  MAINTAINERS                                        |    9 +
>>>>>  drivers/media/platform/Kconfig                     |    1 +
>>>>>  drivers/media/platform/Makefile                    |    2 +
>>>>>  drivers/media/platform/am437x/Kconfig              |   10 +
>>>>>  drivers/media/platform/am437x/Makefile             |    2 +
>>>>>  drivers/media/platform/am437x/vpfe.c               | 2764 ++++++++++++++++++++
>>>>>  drivers/media/platform/am437x/vpfe.h               |  286 ++
>>>>>  drivers/media/platform/am437x/vpfe_regs.h          |  140 +
>>>>>  include/uapi/linux/Kbuild                          |    1 +
>>>>>  include/uapi/linux/am437x_vpfe.h                   |  122 +
>>>>>  11 files changed, 3398 insertions(+)
>>>
>>> Can the source names be improved? There are too many 'vpfe' sources.
>>> Perhaps prefix all with 'am437x-'?
>>>
>> I did think of it but, dropped it as anyway the source's are present
>> in am437x folder, again naming the files am437x-xxx.x didn't make
>> me feel good. If you still insists I'll do it.
>
> Yes, please do. If you look at most other drivers they all have a prefix.
>
> Another reason is that the media_build system expects unique names.
>
OK makes sense I'll prefix it with 'am437x-'. probably fixing all the review
comments i'll post a v2 end of the day.

Thanks,
--Prabhakar Lad

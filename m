Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab3AZEh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 23:37:59 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:33373 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab3AZEh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 23:37:57 -0500
MIME-Version: 1.0
In-Reply-To: <5102E2F4.80604@gmail.com>
References: <1359097268-22779-1-git-send-email-prabhakar.lad@ti.com>
 <1359097268-22779-2-git-send-email-prabhakar.lad@ti.com> <5102E2F4.80604@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 26 Jan 2013 10:07:36 +0530
Message-ID: <CA+V-a8vpZ_UmmsW6D2PBKqg1Nob2PJdVwRDCjdDaPinmjVz8TA@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: add support for decoder subdevs along with
 sensor and others
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

On Sat, Jan 26, 2013 at 1:24 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Prahakar,
>
>
> On 01/25/2013 08:01 AM, Prabhakar Lad wrote:
>>
>> From: Manjunath Hadli<manjunath.hadli@ti.com>
>>
>> A lot of SOCs including Texas Instruments Davinci family mainly use
>> video decoders as input devices. Here the initial subdevice node
>> from where the input really comes is this decoder, for which support
>> is needed as part of the Media Controller infrastructure. This patch
>> adds an additional flag to include the decoders along with others,
>> such as the sensor and lens.
>>
>> Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
>> Signed-off-by: Lad, Prabhakar<prabhakar.lad@ti.com>
>> ---
>>   include/uapi/linux/media.h |    1 +
>>   1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
>> index 0ef8833..fa44ed9 100644
>> --- a/include/uapi/linux/media.h
>> +++ b/include/uapi/linux/media.h
>> @@ -56,6 +56,7 @@ struct media_device_info {
>>   #define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR        (MEDIA_ENT_T_V4L2_SUBDEV +
>> 1)
>>   #define MEDIA_ENT_T_V4L2_SUBDEV_FLASH (MEDIA_ENT_T_V4L2_SUBDEV + 2)
>>   #define MEDIA_ENT_T_V4L2_SUBDEV_LENS  (MEDIA_ENT_T_V4L2_SUBDEV + 3)
>> +#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER        (MEDIA_ENT_T_V4L2_SUBDEV +
>> 4)
>
>
> Such a new entity type needs to be documented in the media DocBook [1].
> It probably also deserves a comment here, as DECODER isn't that obvious
> like the other already existing entity types. I heard people referring
> to a device that encodes analog (composite) video signal into its digital
> representation as an ENCODER. :)
>
>
Thanks for pointing it :), I'll document it and post a v2.

Regards,
--Prabhakar Lad

> [1] http://hverkuil.home.xs4all.nl/spec/media.html#media-ioc-enum-entities
>
> --
>
> Regards,
> Sylwester

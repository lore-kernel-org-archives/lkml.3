Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab3BGMiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:38:05 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39922 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936Ab3BGMiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:38:02 -0500
MIME-Version: 1.0
In-Reply-To: <5113948A.5070209@samsung.com>
References: <1359373843-15956-1-git-send-email-prabhakar.lad@ti.com> <5113948A.5070209@samsung.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 7 Feb 2013 18:07:40 +0530
Message-ID: <CA+V-a8uwV2mZvdqcVuGePre1zoF2D-JuVCS5f_yTacM6EVs2vw@mail.gmail.com>
Subject: Re: [PATCH v2] media: add support for decoder as one of media entity types
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        LDOC <linux-doc@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>, Rob Landley <rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

On Thu, Feb 7, 2013 at 5:18 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> Hi Prabhakar,
>
> On 01/28/2013 12:50 PM, Prabhakar Lad wrote:
>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
>> index 0ef8833..dac06d7 100644
>> --- a/include/uapi/linux/media.h
>> +++ b/include/uapi/linux/media.h
>> @@ -56,6 +56,8 @@ struct media_device_info {
>>  #define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR       (MEDIA_ENT_T_V4L2_SUBDEV + 1)
>>  #define MEDIA_ENT_T_V4L2_SUBDEV_FLASH        (MEDIA_ENT_T_V4L2_SUBDEV + 2)
>>  #define MEDIA_ENT_T_V4L2_SUBDEV_LENS (MEDIA_ENT_T_V4L2_SUBDEV + 3)
>> +/* DECODER: Converts analogue video to digital */
>
> The patch looks good to me, I would just change this comment to
> something like:
>
> /* A converter of analogue video to its digital representation. */
>
> But that's really a nitpicking.
>
OK will fix it and post a v3.

Regards,
--Prabhakar

>> +#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER      (MEDIA_ENT_T_V4L2_SUBDEV + 4)
>>
>>  #define MEDIA_ENT_FL_DEFAULT         (1 << 0)
>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>
> --
>
> Thanks,
> Sylwester

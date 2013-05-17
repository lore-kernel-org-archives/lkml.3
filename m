Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab3EQE5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 00:57:01 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:42388 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3EQE47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 00:56:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130516223739.GB2077@valkosipuli.retiisi.org.uk>
References: <1368619042-28252-1-git-send-email-prabhakar.csengg@gmail.com>
 <1368619042-28252-2-git-send-email-prabhakar.csengg@gmail.com> <20130516223739.GB2077@valkosipuli.retiisi.org.uk>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 17 May 2013 10:26:38 +0530
Message-ID: <CA+V-a8uzz=P9LzVeuzUhX5PTzi_VpFvVfKuGFHkcYaX02w1JrQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] media: i2c: ths7303: remove init_enable option from pdata
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

Thanks for the review.

On Fri, May 17, 2013 at 4:07 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Prabhakar,
>
> Thanks for the patch!
>
> On Wed, May 15, 2013 at 05:27:17PM +0530, Lad Prabhakar wrote:
>> diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
>> index 65853ee..8cddcd0 100644
>> --- a/drivers/media/i2c/ths7303.c
>> +++ b/drivers/media/i2c/ths7303.c
>> @@ -356,9 +356,7 @@ static int ths7303_setup(struct v4l2_subdev *sd)
>>       int ret;
>>       u8 mask;
>>
>> -     state->stream_on = pdata->init_enable;
>> -
>> -     mask = state->stream_on ? 0xff : 0xf8;
>> +     mask = 0xf8;
>
> You can assign mask in declaration. It'd be nice to have a human-readable
> name for the mask, too.
>
This function gets removed in the preceding patch of this series.

Regards,
--Prabhakar Lad

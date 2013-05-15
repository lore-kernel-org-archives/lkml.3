Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3EOFSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 01:18:39 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:59485 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3EOFSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 01:18:37 -0400
MIME-Version: 1.0
In-Reply-To: <4149647.zqpmlIlQDP@avalon>
References: <1368528334-13595-1-git-send-email-prabhakar.csengg@gmail.com>
 <1368528334-13595-6-git-send-email-prabhakar.csengg@gmail.com> <4149647.zqpmlIlQDP@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 15 May 2013 10:48:05 +0530
Message-ID: <CA+V-a8u+peO+6MiZuU_juhYpzHa3yUZbyjeEU3xi3gDhPRb3Bw@mail.gmail.com>
Subject: Re: [PATCH 5/5] media: i2c: tvp7002: add OF support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Thanks for the review.

On Tue, May 14, 2013 at 9:04 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> Thank you for the patch.
>
> On Tuesday 14 May 2013 16:15:34 Lad Prabhakar wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> add OF support for the tvp7002 driver.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: Rob Landley <rob@landley.net>
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Cc: linux-doc@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: davinci-linux-open-source@linux.davincidsp.com
>> ---
>>  .../devicetree/bindings/media/i2c/tvp7002.txt      |   42 +++++++++++++
>>  drivers/media/i2c/tvp7002.c                        |   64 +++++++++++++++--
>>  2 files changed, 99 insertions(+), 7 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp7002.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
>> b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt new file mode
>> 100644
>> index 0000000..1ebd8b1
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
>> @@ -0,0 +1,42 @@
>> +* Texas Instruments TV7002 video decoder
>> +
>> +The TVP7002 device supports digitizing of video and graphics signal in RGB
>> and
>> +YPbPr color space.
>> +
>> +Required Properties :
>> +- compatible : Must be "ti,tvp7002"
>> +
>> +- hsync-active: HSYNC Polarity configuration for endpoint.
>> +
>> +- vsync-active: VSYNC Polarity configuration for endpoint.
>> +
>> +- pclk-sample: Clock polarity of the endpoint.
>> +
>> +- ti,tvp7002-fid-polarity: Active-high Field ID polarity of the endpoint.
>> +
>> +- ti,tvp7002-sog-polarity: Sync on Green output polarity of the endpoint.
>
> Would it make sense to define field-active and sog-active properties in the
> V4L2 bindings instead of having per-chip properties ?
>
yes you are right these properties need to be in the device node
rather than the
port node. I'll send alone this patch of the series as v2 fixing the above.

Regards,
--Prabhakar Lad

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036Ab3GZOYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 10:24:19 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:43343 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab3GZOYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:24:17 -0400
MIME-Version: 1.0
In-Reply-To: <51F24AD0.1050808@xs4all.nl>
References: <1374162866-14981-1-git-send-email-prabhakar.csengg@gmail.com> <51F24AD0.1050808@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 26 Jul 2013 19:53:55 +0530
Message-ID: <CA+V-a8vmPf7mkbExAadwh0TRKwT220BQRJ3njfqyqsxOLHSe6g@mail.gmail.com>
Subject: Re: [PATCH v4] media: i2c: tvp7002: add OF support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

Thanks for the review.

On Fri, Jul 26, 2013 at 3:39 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Prabhakar,
>
> On 07/18/2013 05:54 PM, Lad, Prabhakar wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> add OF support for the tvp7002 driver.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  This patch depends on https://patchwork.kernel.org/patch/2828800/
>>
>>  Changes for v4:
>>  1: Improved descrition of end point properties.
>>
>>  Changes for v3:
>>  1: Fixed review comments pointed by Sylwester.
>>
>>  .../devicetree/bindings/media/i2c/tvp7002.txt      |   53 ++++++++++++++++
>>  drivers/media/i2c/tvp7002.c                        |   67 ++++++++++++++++++--
>>  2 files changed, 113 insertions(+), 7 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp7002.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp7002.txt b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
>> new file mode 100644
>> index 0000000..1d00935
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
>> @@ -0,0 +1,53 @@
>> +* Texas Instruments TV7002 video decoder
>> +
>> +The TVP7002 device supports digitizing of video and graphics signal in RGB and
>> +YPbPr color space.
>> +
>> +Required Properties :
>> +- compatible : Must be "ti,tvp7002"
>> +
>> +Optional Properties:
>> +- hsync-active: HSYNC Polarity configuration for the bus. Default value when
>> +  this property is not specified is <0>.
>> +
>> +- vsync-active: VSYNC Polarity configuration for the bus. Default value when
>> +  this property is not specified is <0>.
>> +
>> +- pclk-sample: Clock polarity of the bus. Default value when this property is
>> +  not specified is <0>.
>> +
>> +- sync-on-green-active: Active state of Sync-on-green signal property of the
>> +  endpoint.
>> +  0 = Normal Operation (Default)
>
> I would extend this a little bit:
>
>   0 = Normal Operation (Active Low, Default)
>
Ok.

>> +  1 = Inverted operation
>> +
>> +- field-even-active: Active-high Field ID output polarity control of the bus.
>> +  Under normal operation, the field ID output is set to logic 1 for an odd field
>> +  (field 1)and set to logic 0 for an even field (field 0).
>
> Add space before 'and'.
>
Ok will fix it.

Regards,
--Prabhakar Lad

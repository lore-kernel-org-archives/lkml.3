Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3BCQKu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 11:10:50 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:54183 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab3BCQKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 11:10:47 -0500
MIME-Version: 1.0
In-Reply-To: <510E61B7.6030904@ti.com>
References: <1359464832-8875-1-git-send-email-prabhakar.lad@ti.com>
 <510C43A0.7090906@gmail.com> <CA+V-a8u6VADw_HfbBN4ESGUXTSMKfVyKZaEf1bhVGACof6qZ8A@mail.gmail.com>
 <510E61B7.6030904@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sun, 3 Feb 2013 21:40:25 +0530
Message-ID: <CA+V-a8vjCbSU8jji48oNq6UBfnOj_bYf_tQn3AU3CW_ToY6e5w@mail.gmail.com>
Subject: Re: [PATCH RFC v2] media: tvp514x: add OF support
To: Sekhar Nori <nsekhar@ti.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Rob Landley <rob@landley.net>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sekhar,

On Sun, Feb 3, 2013 at 6:40 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> On 2/3/2013 3:43 PM, Prabhakar Lad wrote:
>> Hi Sylwester,
>>
>> Thanks for the review.
>>
>> On Sat, Feb 2, 2013 at 4:07 AM, Sylwester Nawrocki
>> <sylvester.nawrocki@gmail.com> wrote:
>>> Hi Prabhakar,
>>>
>>> On 01/29/2013 02:07 PM, Prabhakar Lad wrote:
>>> [...]
>>>
>>>> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
>>>> b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
>>>> new file mode 100644
>>>> index 0000000..55d3ffd
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
>>>> @@ -0,0 +1,38 @@
>>>> +* Texas Instruments TVP514x video decoder
>>>> +
>>>> +The TVP5146/TVP5146m2/TVP5147/TVP5147m1 device is high quality,
>>>> single-chip
>>>> +digital video decoder that digitizes and decodes all popular baseband
>>>> analog
>>>> +video formats into digital video component. The tvp514x decoder supports
>>>> analog-
>>>> +to-digital (A/D) conversion of component RGB and YPbPr signals as well as
>>>> A/D
>>>> +conversion and decoding of NTSC, PAL and SECAM composite and S-video into
>>>> +component YCbCr.
>>>> +
>>>> +Required Properties :
>>>> +- compatible: Must be "ti,tvp514x-decoder"
>>>
>>>
>>> There are no significant differences among TVP514* devices as listed above,
>>> you would like to handle above ?
>>>
>>> I'm just wondering if you don't need ,for instance, two separate compatible
>>> properties, e.g. "ti,tvp5146-decoder" and "ti,tvp5147-decoder" ?
>>>
>> There are few differences in init/power sequence tough, I would still
>> like to have
>> single compatible property "ti,tvp514x-decoder", If you feel we need separate
>> property I will change it please let me know on this.
>
> Compatible properties should not use generic part numbers. See one past
> discussion here: http://en.usenet.digipedia.org/thread/18472/20788/
>
Thanks for the link, I'll have separate compatible properties.

Regards,
--Prabhakar

> Thanks,
> Sekhar

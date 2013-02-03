Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3BCQMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 11:12:38 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:60731 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab3BCQMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 11:12:35 -0500
MIME-Version: 1.0
In-Reply-To: <1832736.hCOhBbmy4r@avalon>
References: <1359464832-8875-1-git-send-email-prabhakar.lad@ti.com>
 <510C43A0.7090906@gmail.com> <CA+V-a8u6VADw_HfbBN4ESGUXTSMKfVyKZaEf1bhVGACof6qZ8A@mail.gmail.com>
 <1832736.hCOhBbmy4r@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sun, 3 Feb 2013 21:42:14 +0530
Message-ID: <CA+V-a8vocaoA=zTkSGX7Mi5QdjhzZPCAd3SThFv3uKQxwSTpsA@mail.gmail.com>
Subject: Re: [PATCH RFC v2] media: tvp514x: add OF support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Sun, Feb 3, 2013 at 6:44 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> On Sunday 03 February 2013 15:43:49 Prabhakar Lad wrote:
>> On Sat, Feb 2, 2013 at 4:07 AM, Sylwester Nawrocki wrote:
>> > On 01/29/2013 02:07 PM, Prabhakar Lad wrote:
>> > [...]
>> >
>> >> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
>> >> b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
>> >> new file mode 100644
>> >> index 0000000..55d3ffd
>> >> --- /dev/null
>> >> +++ b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
>> >> @@ -0,0 +1,38 @@
>> >> +* Texas Instruments TVP514x video decoder
>> >> +
>> >> +The TVP5146/TVP5146m2/TVP5147/TVP5147m1 device is high quality,
>> >> +single-chip digital video decoder that digitizes and decodes all popular
>> >> +baseband analog video formats into digital video component. The tvp514x
>> >> +decoder supports analog-to-digital (A/D) conversion of component RGB and
>> >> +YPbPr signals as well as A/D conversion and decoding of NTSC, PAL and
>> >> +SECAM composite and S-video into component YCbCr.
>> >> +
>> >> +Required Properties :
>> >> +- compatible: Must be "ti,tvp514x-decoder"
>> >
>> > There are no significant differences among TVP514* devices as listed
>> > above, you would like to handle above ?
>> >
>> > I'm just wondering if you don't need, for instance, two separate
>> > compatible properties, e.g. "ti,tvp5146-decoder" and "ti,tvp5147-decoder"
>> > ?
>>
>> There are few differences in init/power sequence tough, I would still
>> like to have single compatible property "ti,tvp514x-decoder", If you feel we
>> need separate property I will change it please let me know on this.
>
> If there's any difference between the chips that need to be handled in the
> driver, using two compatible properties is a good practice. Your driver will
> then be able to easily differentiate between the two chips, and there's no
> real drawback in doing so.
>
Ok I'll will have separate compatible properties.

Regards,
--Prabhakar

> --
> Regards,
>
> Laurent Pinchart
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965365AbaD2WUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:20:49 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:51709 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965265AbaD2WUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:20:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140429071610.63ccdfae.m.chehab@samsung.com>
References: <CAGG=RuYdtfjJf5wKG92KdyKuG6AiBHp2_OSH8Wemi3yQOsouMQ@mail.gmail.com>
 <CA+55aFzhydSCJqMLoUX59cLpiwbnoXtL524O5VtQ4-CVj8HxyA@mail.gmail.com>
 <20140428214000.GA9187@gmail.com> <20140429071610.63ccdfae.m.chehab@samsung.com>
From: Brian Healy <healybrian@gmail.com>
Date: Tue, 29 Apr 2014 23:20:23 +0100
Message-ID: <CAGG=RuZ-uuJPq3cQJkZkHdDV=1t2Z_y=+ZC-gBq8dq7DmytmGA@mail.gmail.com>
Subject: Re: [PATCH] Kernel 3.15-rc2 : Peak DVB-T USB tuner device ids for
 rtl28xxu driver
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti Palosaari <crope@iki.fi>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Mauro,

I'll know for next time. It's my first patch submission so wasn't
aware of the formatting rules.

Brian

On 29 April 2014 15:16, Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:
> Em Mon, 28 Apr 2014 22:40:00 +0100
> Brian Healy <healybrian@gmail.com> escreveu:
>
>> From: Brian Healy <healybrian@gmail.com>
>> To: Antti Palosaari <crope@iki.fi>, Mauro Carvalho Chehab <m.chehab@samsung.com>
>> Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Media Mailing List <linux-media@vger.kernel.org>
>> Subject: Re: [PATCH] Kernel 3.15-rc2 : Peak DVB-T USB tuner device ids for rtl28xxu driver
>> Date: Mon, 28 Apr 2014 22:40:00 +0100
>> Sender: linux-media-owner@vger.kernel.org
>> User-Agent: Mutt/1.5.21 (2010-09-15)
>>
>> On Sun, Apr 27, 2014 at 03:19:12PM -0700, Linus Torvalds wrote:
>>
>> Hi Linus,
>>
>> apologies, i've changed email clients in order to preserve the
>> formatting this time around. The patch is now included inline as an
>> attachment. I ran the script but noticed you've already cc'd the
>> appropriate people.
>>
>> Brian.
>>
>>
>> Resubmitting modified patch. It's purpose is to add the appropriate
>> device/usb ids for the "Peak DVT-B usb dongle" to the rtl28xxu.c driver.
>>
>> Signed-off-by: Brian Healy <healybrian <at> gmail.com>
>>
>>
>> > Brian, please use
>> >
>> >  ./scripts/get_maintainer -f drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>> >
>> > to get the proper people to send this to, so that it doesn't get lost
>> > in the flood in lkml.
>> >
>> > The indentation of that new entry also seems to be suspect, in that it
>> > doesn't match the ones around it.
>> >
>> > Quoting full email for context for people added.
>> >
>> >              Linus
>> >
>>
>> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>> index 61d196e..b6e20cc 100644
>> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>> @@ -1499,6 +1499,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
>>               &rtl2832u_props, "Crypto ReDi PC 50 A", NULL) },
>>       { DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
>>               &rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
>> +        { DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd395,
>> +                &rtl2832u_props, "Peak DVB-T USB", NULL) },
>
> Patch is still a little odd, as you're using spaces for indenting, instead of
> tabs, but I can fix it with my scripts. Next time, please use tabs.
>
> Also, specifically in the case of patches for linux-media, you don't need
> to c/c me. Just send the patch to linux-media and to the driver maintainer
> (Antti, in this case).
>
> My workflow is to pick the patches from patchwork:
>         https://patchwork.linuxtv.org/patch/23792/
> after receiving Antti's ack.
>
> Alternatively, Antti may opt to put it on his git tree, sending it to me
> latter together of other patches he may have for the devices he maintains.
>
>>
>>       /* RTL2832P devices: */
>>       { DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
>
> Thanks,
> Mauro

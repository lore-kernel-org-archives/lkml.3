Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaJBTmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:42:00 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:40733 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaJBTl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:41:59 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <542DA8B2.6030608@free-electrons.com>
References: <1412225138-16158-1-git-send-email-michael.opdenacker@free-electrons.com> <CAH6sp9Ozkhqa=CJa6YXUwoKHn68VvrsohZu099obGN01ZFCwmA@mail.gmail.com> <542DA8B2.6030608@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] [TRIVIAL] mod_devicetable.h: grammar fix in comment
From: Frans Klaver <fransklaver@gmail.com>
Date: Thu, 02 Oct 2014 21:41:46 +0200
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
CC: Jiri Kosina <trivial@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        johannes.thumshirn@men.de, joshc@codeaurora.org, dl9pf@gmx.de,
        behanw@converseincode.com, kheitke@codeaurora.org,
        ard.biesheuvel@linaro.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Opdenacker <michael@free-electrons.com>
Message-ID: <9BC1307A-4C4E-4180-AEA7-22B52DD77D42@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 October 2014 21:34:10 CEST, Michael Opdenacker <michael.opdenacker@free-electrons.com> wrote:
>Hi Frans,
>
>On 10/02/2014 09:43 AM, Frans Klaver wrote:
>> On Thu, Oct 2, 2014 at 6:45 AM, Michael Opdenacker
>> <michael.opdenacker@free-electrons.com> wrote:
>>> Signed-off-by: Michael Opdenacker
><michael.opdenacker@free-electrons.com>
>>> ---
>>>  include/linux/mod_devicetable.h | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/mod_devicetable.h
>b/include/linux/mod_devicetable.h
>>> index 44eeef0da186..745def862580 100644
>>> --- a/include/linux/mod_devicetable.h
>>> +++ b/include/linux/mod_devicetable.h
>>> @@ -69,7 +69,7 @@ struct ieee1394_device_id {
>>>   * @bDeviceClass: Class of device; numbers are assigned
>>>   *     by the USB forum.  Products may choose to implement classes,
>>>   *     or be vendor-specific.  Device classes specify behavior of
>all
>>> - *     the interfaces on a devices.
>>> + *     the interfaces on a device.
>>>   * @bDeviceSubClass: Subclass of device; associated with
>bDeviceClass.
>>>   * @bDeviceProtocol: Protocol of device; associated with
>bDeviceClass.
>>>   * @bInterfaceClass: Class of interface; numbers are assigned
>>> --
>>> 1.9.1
>> Well whaddayaknow, I ran into the same thing last month.
>>
>> https://lkml.org/lkml/2014/9/3/871
>
>Hey, you were first. Happy to drop my identical patch.
>
>Thanks :)

I don't mind either way. It should get fixed :) 

Cheers, 
Frans 



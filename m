Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaJBTeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:34:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43419 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752590AbaJBTeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:34:12 -0400
Message-ID: <542DA8B2.6030608@free-electrons.com>
Date: Thu, 02 Oct 2014 21:34:10 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Frans Klaver <fransklaver@gmail.com>
CC: Jiri Kosina <trivial@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        johannes.thumshirn@men.de, joshc@codeaurora.org, dl9pf@gmx.de,
        behanw@converseincode.com, kheitke@codeaurora.org,
        ard.biesheuvel@linaro.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Opdenacker <michael@free-electrons.com>
Subject: Re: [PATCH] [TRIVIAL] mod_devicetable.h: grammar fix in comment
References: <1412225138-16158-1-git-send-email-michael.opdenacker@free-electrons.com> <CAH6sp9Ozkhqa=CJa6YXUwoKHn68VvrsohZu099obGN01ZFCwmA@mail.gmail.com>
In-Reply-To: <CAH6sp9Ozkhqa=CJa6YXUwoKHn68VvrsohZu099obGN01ZFCwmA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frans,

On 10/02/2014 09:43 AM, Frans Klaver wrote:
> On Thu, Oct 2, 2014 at 6:45 AM, Michael Opdenacker
> <michael.opdenacker@free-electrons.com> wrote:
>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
>> ---
>>  include/linux/mod_devicetable.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
>> index 44eeef0da186..745def862580 100644
>> --- a/include/linux/mod_devicetable.h
>> +++ b/include/linux/mod_devicetable.h
>> @@ -69,7 +69,7 @@ struct ieee1394_device_id {
>>   * @bDeviceClass: Class of device; numbers are assigned
>>   *     by the USB forum.  Products may choose to implement classes,
>>   *     or be vendor-specific.  Device classes specify behavior of all
>> - *     the interfaces on a devices.
>> + *     the interfaces on a device.
>>   * @bDeviceSubClass: Subclass of device; associated with bDeviceClass.
>>   * @bDeviceProtocol: Protocol of device; associated with bDeviceClass.
>>   * @bInterfaceClass: Class of interface; numbers are assigned
>> --
>> 1.9.1
> Well whaddayaknow, I ran into the same thing last month.
>
> https://lkml.org/lkml/2014/9/3/871

Hey, you were first. Happy to drop my identical patch.

Thanks :)

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbaAJGzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 01:55:52 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:58451 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaAJGzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 01:55:50 -0500
MIME-Version: 1.0
In-Reply-To: <52CF8455.5090506@ti.com>
References: <CAAfyv37aM6SrpuU9fzKA6GKsWn=To5ANOpG_kSX509NjMjdecA@mail.gmail.com>
	<529F1E89.6080700@ti.com>
	<CAAfyv36sNyEiEHEOKfZWN1xRYLGUt-NW18uhcJbSTWRBA5=2BA@mail.gmail.com>
	<52CE32AB.1050204@ti.com>
	<52CF8455.5090506@ti.com>
Date: Fri, 10 Jan 2014 07:55:48 +0100
Message-ID: <CAAfyv34ce=V_nheonE0HLGPNEF=Z_Ep-hj64dSuKrRqehNfOCw@mail.gmail.com>
Subject: Re: 3.13-rc2 phy-twl4030-usb.c - Timeout setting T2 HSUSB PHY DPLL
From: Belisko Marek <marek.belisko@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Roger Quadros <rogerq@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jan 10, 2014 at 6:25 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi,
>
> On Thursday 09 January 2014 10:54 AM, Roger Quadros wrote:
>> Hi Marek,
>>
>> I have no idea what is happening there. Have you tried using device tree boot?
>> Board file boot support would be dropped eventually.
>>
>> Did you try if I2C read write to the twl4030 device works and all necessary clocks/supplies are
>> present?
>>
>> Kishon, do you know what is causing the USB DPLL failure there?
Issue was fixed. There was in 3.13-rc7 issue with unable to find phy
(phy was twl4030_usb). After that
issue is gone.
>
> Not sure what's causing those failures :-s
>
> -Kishon
>
>>
>> cheers,
>> -roger
>>
>> On 01/09/2014 02:31 AM, Belisko Marek wrote:
>>> Any pointers? Still present in 3.13-rc7.
>>>
>>> On Wed, Dec 4, 2013 at 1:22 PM, Roger Quadros <rogerq@ti.com> wrote:
>>>> +Kishon
>>>>
>>>> On 12/03/2013 11:33 PM, Belisko Marek wrote:
>>>>> Hi,
>>>>>
>>>>> current 3.13-rcX break usb support on gta04 board (similar to
>>>>> beagleboard) when booting via board file.
>>>>>
>>>>> In console we can see messages:
>>>>>  [ 5227.287841] twl4030_usb twl4030_usb: Timeout setting T2 HSUSB PHY DPLL clock
>>>>> [ 5232.936096] omap_musb_mailbox: musb core is not yet ready
>>>>> [ 5233.958160] twl4030_usb twl4030_usb: Timeout setting T2 HSUSB PHY DPLL clock
>>>>> [ 5235.058227] twl4030_usb twl4030_usb: Timeout setting T2 HSUSB PHY DPLL clock
>>>>>
>>>>> Any pointer what could cause that? (in 3.12 usb works fine)
>>>>>
>>>>> BR,
>>>>>
>>>>> marek
>>>>>
>>>>
>>>
>>> BR,
>>>
>>> marek
>>>
>>
>

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com

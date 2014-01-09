Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbaAIFZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 00:25:28 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58460 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbaAIFZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 00:25:27 -0500
Message-ID: <52CE32AB.1050204@ti.com>
Date: Thu, 9 Jan 2014 10:54:59 +0530
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Belisko Marek <marek.belisko@gmail.com>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: 3.13-rc2 phy-twl4030-usb.c - Timeout setting T2 HSUSB PHY DPLL
References: <CAAfyv37aM6SrpuU9fzKA6GKsWn=To5ANOpG_kSX509NjMjdecA@mail.gmail.com>	<529F1E89.6080700@ti.com> <CAAfyv36sNyEiEHEOKfZWN1xRYLGUt-NW18uhcJbSTWRBA5=2BA@mail.gmail.com>
In-Reply-To: <CAAfyv36sNyEiEHEOKfZWN1xRYLGUt-NW18uhcJbSTWRBA5=2BA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

I have no idea what is happening there. Have you tried using device tree boot?
Board file boot support would be dropped eventually.

Did you try if I2C read write to the twl4030 device works and all necessary clocks/supplies are
present?

Kishon, do you know what is causing the USB DPLL failure there?

cheers,
-roger

On 01/09/2014 02:31 AM, Belisko Marek wrote:
> Any pointers? Still present in 3.13-rc7.
> 
> On Wed, Dec 4, 2013 at 1:22 PM, Roger Quadros <rogerq@ti.com> wrote:
>> +Kishon
>>
>> On 12/03/2013 11:33 PM, Belisko Marek wrote:
>>> Hi,
>>>
>>> current 3.13-rcX break usb support on gta04 board (similar to
>>> beagleboard) when booting via board file.
>>>
>>> In console we can see messages:
>>>  [ 5227.287841] twl4030_usb twl4030_usb: Timeout setting T2 HSUSB PHY DPLL clock
>>> [ 5232.936096] omap_musb_mailbox: musb core is not yet ready
>>> [ 5233.958160] twl4030_usb twl4030_usb: Timeout setting T2 HSUSB PHY DPLL clock
>>> [ 5235.058227] twl4030_usb twl4030_usb: Timeout setting T2 HSUSB PHY DPLL clock
>>>
>>> Any pointer what could cause that? (in 3.12 usb works fine)
>>>
>>> BR,
>>>
>>> marek
>>>
>>
> 
> BR,
> 
> marek
> 


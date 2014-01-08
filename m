Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbaAHVBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:01:31 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:41684 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757026AbaAHVBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:01:24 -0500
MIME-Version: 1.0
In-Reply-To: <529F1E89.6080700@ti.com>
References: <CAAfyv37aM6SrpuU9fzKA6GKsWn=To5ANOpG_kSX509NjMjdecA@mail.gmail.com>
	<529F1E89.6080700@ti.com>
Date: Wed, 8 Jan 2014 22:01:24 +0100
Message-ID: <CAAfyv36sNyEiEHEOKfZWN1xRYLGUt-NW18uhcJbSTWRBA5=2BA@mail.gmail.com>
Subject: Re: 3.13-rc2 phy-twl4030-usb.c - Timeout setting T2 HSUSB PHY DPLL
From: Belisko Marek <marek.belisko@gmail.com>
To: Roger Quadros <rogerq@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any pointers? Still present in 3.13-rc7.

On Wed, Dec 4, 2013 at 1:22 PM, Roger Quadros <rogerq@ti.com> wrote:
> +Kishon
>
> On 12/03/2013 11:33 PM, Belisko Marek wrote:
>> Hi,
>>
>> current 3.13-rcX break usb support on gta04 board (similar to
>> beagleboard) when booting via board file.
>>
>> In console we can see messages:
>>  [ 5227.287841] twl4030_usb twl4030_usb: Timeout setting T2 HSUSB PHY DPLL clock
>> [ 5232.936096] omap_musb_mailbox: musb core is not yet ready
>> [ 5233.958160] twl4030_usb twl4030_usb: Timeout setting T2 HSUSB PHY DPLL clock
>> [ 5235.058227] twl4030_usb twl4030_usb: Timeout setting T2 HSUSB PHY DPLL clock
>>
>> Any pointer what could cause that? (in 3.12 usb works fine)
>>
>> BR,
>>
>> marek
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

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762474Ab3DCLy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 07:54:29 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:64582 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761190Ab3DCLy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 07:54:27 -0400
Message-ID: <515C1860.1040600@openwrt.org>
Date: Wed, 03 Apr 2013 13:54:08 +0200
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: balbi@ti.com
CC: stern@rowland.harvard.edu, linux-kernel@vger.kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/5 v2] USB: regroup all depends on USB within an if USB
 block
References: <1364321177-12146-1-git-send-email-florian@openwrt.org> <1364922626-32407-1-git-send-email-florian@openwrt.org> <1364922626-32407-2-git-send-email-florian@openwrt.org> <20130402181931.GA21830@arwen.pp.htv.fi>
In-Reply-To: <20130402181931.GA21830@arwen.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 04/02/13 20:19, balbi@ti.com a écrit :
> Hi,
>
> On Tue, Apr 02, 2013 at 07:10:22PM +0200, Florian Fainelli wrote:
>> diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
>> index 05e5143..ab5a3b9 100644
>> --- a/drivers/usb/musb/Kconfig
>> +++ b/drivers/usb/musb/Kconfig
>> @@ -6,7 +6,6 @@
>>   # (M)HDRC = (Multipoint) Highspeed Dual-Role Controller
>>   config USB_MUSB_HDRC
>>   	tristate 'Inventra Highspeed Dual Role Controller (TI, ADI, ...)'
>> -	depends on USB && USB_GADGET
>
> shouldn't:
>
> depends on USB_GADGET
>
> be left here ?

Indeed this should be left there. Thanks!
--
Florian

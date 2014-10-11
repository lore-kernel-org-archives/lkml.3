Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaJKOvP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 10:51:15 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41910 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbaJKOvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 10:51:14 -0400
Message-ID: <543943D8.2020004@gmail.com>
Date: Sat, 11 Oct 2014 21:51:04 +0700
From: Lars Melin <larsm17@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        Philip Munksgaard <pmunksgaard@gmail.com>
CC: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: serial: Fix indentation style issue
References: <1413035383-3981-1-git-send-email-pmunksgaard@gmail.com> <20141011142049.GA11456@kroah.com>
In-Reply-To: <20141011142049.GA11456@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-11 21:20, Greg KH wrote:
> On Sat, Oct 11, 2014 at 03:49:43PM +0200, Philip Munksgaard wrote:
>> Fix a style issue
>>
>> Signed-off-by: Philip Munksgaard <pmunksgaard@gmail.com>
>> ---
>>   drivers/usb/serial/option.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
>> index d1a3f60..d88998d 100644
>> --- a/drivers/usb/serial/option.c
>> +++ b/drivers/usb/serial/option.c
>> @@ -1616,7 +1616,7 @@ static const struct usb_device_id option_ids[] = {
>>   	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
>>   	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),
>>     	  .driver_info = (kernel_ulong_t)&four_g_w14_blacklist
>> -  	},
>> +	},
> Why not fix the same 'space' issue on the line before this at the same
> time?
>
Why put the closing brace on a new line?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbaD3H6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 03:58:22 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:33181 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbaD3H6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 03:58:20 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s3U7v66k029654, This message is accepted by code: ctloc85258
Message-ID: <5360ACA4.80503@realtek.com>
Date: Wed, 30 Apr 2014 15:56:20 +0800
From: Roger <rogerable@realtek.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Chris Ball <chris@printf.net>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oliver Neukum <oneukum@suse.de>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <driverdev-devel@linuxdriverproject.org>,
        <wei_wang@realsil.com.cn>, <micky_ching@realsil.com.cn>
Subject: Re: [PATCH v7 4/4] memstick: Add realtek USB memstick host driver
References: <1397199203-2235-1-git-send-email-rogerable@realtek.com> <1397199203-2235-5-git-send-email-rogerable@realtek.com> <20140428101010.GR6264@lee--X1>
In-Reply-To: <20140428101010.GR6264@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 06:10 PM, Lee Jones wrote:
>> From: Roger Tseng <rogerable@realtek.com>
>>
>> Realtek USB memstick host driver provides memstick host support based on the
>> Realtek USB card reader MFD driver.
>>
>> Signed-off-by: Roger Tseng <rogerable@realtek.com>
>> ---
>>   drivers/memstick/host/Kconfig       |  10 +
>>   drivers/memstick/host/Makefile      |   1 +
>>   drivers/memstick/host/rtsx_usb_ms.c | 839 ++++++++++++++++++++++++++++++++++++
>>   3 files changed, 850 insertions(+)
>>   create mode 100644 drivers/memstick/host/rtsx_usb_ms.c
>
> Applied, thanks.
>
Greg,

Since all patches have been applied and the device is now supported by 
the new driver, would you remove the former staging one at 
drivers/staging/rts5139? Similar removal had been done for our PCIE 
devices in:

commit cd2112220b6b0a35fa12ba988a0dd837515dfaf8
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Fri Oct 26 09:03:21 2012 -0700

     Staging: remove rts_pstor driver


Best regards,
Roger Tseng

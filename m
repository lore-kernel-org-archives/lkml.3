Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaBKJin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:38:43 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:58041 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaBKJik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:38:40 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s1B9bqca013015, This message is accepted by code: ctloc85258
Message-ID: <52F9F012.8030302@realtek.com>
Date: Tue, 11 Feb 2014 17:40:34 +0800
From: Roger <rogerable@realtek.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <driverdev-devel@linuxdriverproject.org>, <wei_wang@realsil.com.cn>,
        <micky_ching@realsil.com.cn>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v3 1/3] mfd: Add realtek USB card reader driver
References: <1391697307-23457-1-git-send-email-rogerable@realtek.com> <1391697307-23457-2-git-send-email-rogerable@realtek.com> <20140210113054.GE21522@lee--X1>
In-Reply-To: <20140210113054.GE21522@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 07:30 PM, Lee Jones wrote:
>> From: Roger Tseng <rogerable@realtek.com>
>>
>> Realtek USB card reader provides a channel to transfer command or data to flash
>> memory cards. This driver exports host instances for mmc and memstick subsystems
>> and handles basic works.
>>
>> Signed-off-by: Roger Tseng <rogerable@realtek.com>
>> ---
>>   drivers/mfd/Kconfig          |  10 +
>>   drivers/mfd/Makefile         |   1 +
>>   drivers/mfd/rtsx_usb.c       | 760 +++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/mfd/rtsx_usb.h | 628 +++++++++++++++++++++++++++++++++++
>>   4 files changed, 1399 insertions(+)
>>   create mode 100644 drivers/mfd/rtsx_usb.c
>>   create mode 100644 include/linux/mfd/rtsx_usb.h
>
> Applied with Greg's Ack.
>
Thanks. But I have to modify some places in PATCH 2/3 and 3/3 according 
to Ulf's suggestion. I will resend v4 later but currently I don't plan 
to change the 1/3 part(for mfd) in it.

Would you wait for and re-apply the v4 submission or give any advice?

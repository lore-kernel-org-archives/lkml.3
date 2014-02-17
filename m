Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaBQGJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 01:09:11 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:53049 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaBQGJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 01:09:07 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s1H66mlo005337, This message is accepted by code: ctloc85258
Message-ID: <5301A786.8040607@realtek.com>
Date: Mon, 17 Feb 2014 14:09:10 +0800
From: Roger <rogerable@realtek.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <driverdev-devel@linuxdriverproject.org>,
        <wei_wang@realsil.com.cn>, <micky_ching@realsil.com.cn>
Subject: Re: [PATCH v4 1/3] mfd: Add realtek USB card reader driver
References: <1392199238-14500-1-git-send-email-rogerable@realtek.com> <1392199238-14500-2-git-send-email-rogerable@realtek.com> <20140214094427.GA7380@lee--X1>
In-Reply-To: <20140214094427.GA7380@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 05:44 PM, Lee Jones wrote:
> On Wed, 12 Feb 2014, rogerable@realtek.com wrote:
>
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
> Applied again, thanks.
>
Would you also apply patch 2/3 and 3/3 that to make the device fully 
operational for users? Or should they be applied by maintainers of 
mmc/memstick subsystems?

Chris, would you give some comment?

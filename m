Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaDYHH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:07:56 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:33735 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaDYHHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:07:53 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s3P774Tf001561, This message is accepted by code: ctloc85258
Message-ID: <535A096A.3070603@realtek.com>
Date: Fri, 25 Apr 2014 15:06:18 +0800
From: Roger <rogerable@realtek.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, Oliver Neukum <oneukum@suse.de>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <driverdev-devel@linuxdriverproject.org>, <wei_wang@realsil.com.cn>,
        <micky_ching@realsil.com.cn>
Subject: Re: [PATCH v7 4/4] memstick: Add realtek USB memstick host driver
References: <1397199203-2235-1-git-send-email-rogerable@realtek.com> <1397199203-2235-5-git-send-email-rogerable@realtek.com> <20140416081352.GA4754@lee--X1>
In-Reply-To: <20140416081352.GA4754@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/16/2014 04:13 PM, Lee Jones wrote:
> Hi Andrew,
>
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
> It seems Max and Alex are less than interested in this patch, so I'm
> going to apply it anyway. In your last review you mentioned that it
> looked good to your inexpert eye. Can I apply your Ack to that effect?
>
Hi Andrew,

Would you confirm the Ack for Lee?

Best regards,
Roger Tseng

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379AbaBKJz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:55:29 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:63175 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaBKJzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:55:23 -0500
MIME-Version: 1.0
In-Reply-To: <52F9F012.8030302@realtek.com>
References: <1391697307-23457-1-git-send-email-rogerable@realtek.com>
	<1391697307-23457-2-git-send-email-rogerable@realtek.com>
	<20140210113054.GE21522@lee--X1>
	<52F9F012.8030302@realtek.com>
Date: Tue, 11 Feb 2014 10:55:22 +0100
Message-ID: <CAPDyKFqzbz_A+hiTeodKXh30BMuY4ONN9bxy=5Mo1vi9SZyERQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mfd: Add realtek USB card reader driver
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Roger <rogerable@realtek.com>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org,
        Wei WANG <wei_wang@realsil.com.cn>, micky_ching@realsil.com.cn
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 February 2014 10:40, Roger <rogerable@realtek.com> wrote:
> On 02/10/2014 07:30 PM, Lee Jones wrote:
>>>
>>> From: Roger Tseng <rogerable@realtek.com>
>>>
>>> Realtek USB card reader provides a channel to transfer command or data to
>>> flash
>>> memory cards. This driver exports host instances for mmc and memstick
>>> subsystems
>>> and handles basic works.
>>>
>>> Signed-off-by: Roger Tseng <rogerable@realtek.com>
>>> ---
>>>   drivers/mfd/Kconfig          |  10 +
>>>   drivers/mfd/Makefile         |   1 +
>>>   drivers/mfd/rtsx_usb.c       | 760
>>> +++++++++++++++++++++++++++++++++++++++++++
>>>   include/linux/mfd/rtsx_usb.h | 628 +++++++++++++++++++++++++++++++++++
>>>   4 files changed, 1399 insertions(+)
>>>   create mode 100644 drivers/mfd/rtsx_usb.c
>>>   create mode 100644 include/linux/mfd/rtsx_usb.h
>>
>>
>> Applied with Greg's Ack.
>>
> Thanks. But I have to modify some places in PATCH 2/3 and 3/3 according to
> Ulf's suggestion. I will resend v4 later but currently I don't plan to
> change the 1/3 part(for mfd) in it.
>
> Would you wait for and re-apply the v4 submission or give any advice?

Just send a v4 of PATCH 2/3 and 3/3, that should be fine I think.

Kind regards
Ulf Hansson

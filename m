Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab3GYP2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:28:39 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:43287 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941Ab3GYP2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:28:38 -0400
MIME-Version: 1.0
In-Reply-To: <51F14165.3060803@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
	<1374516607-2705-7-git-send-email-bigeasy@linutronix.de>
	<CADYTM3avh7GFTDQW01FnojKZkmL0_hi+=K-VVwCw5peJL2hwTA@mail.gmail.com>
	<20130725144118.GA5412@linutronix.de>
	<CADYTM3bJZKUjgddP1pddZvqg7CfVyayxEXfBoJFrhean79+ykA@mail.gmail.com>
	<51F14165.3060803@linutronix.de>
Date: Thu, 25 Jul 2013 10:28:37 -0500
Message-ID: <CADYTM3Z1aoTx_99xCj9XOQCUj63GeCcekL6ECajWQWKoQD4n0Q@mail.gmail.com>
Subject: Re: [PATCH 06/16] usb: musb: dsps: rename ti81xx_driver_data to am33xx_driver_data
From: Bin Liu <binmlist@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Thu, Jul 25, 2013 at 10:16 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> On 07/25/2013 05:12 PM, Bin Liu wrote:
>> Sebastian,
>
> Hi Bin,
>
>>> Is it really there or was it never there and it has been added to TRM by
>>> accident?
>> The EOI register IS in the USB subsystem of AM33xx, but the SoC does
>> not use it because it uses level triggering for USB interrupt.
>
> I see.
>
>>>> But I am not sure if it is a good idea to remove eoi from the musb_dsps
>>>> driver. If the intension is to merge the support for other SoC, such as
>>>> AM35xx, AM18xx, then EOI handling might be still needed. I just don't know
>>>> how those devices use EOI.
>>>
>>> If one of the architectures gets added which need an EOI then the offset
>>> can be 0 and the EOI will happen only if it is != 0.
>> This patch cleaned up the use of EOI. Do you mean EOI handling will be
>> added back with condition EOI offset != 0, when the support of new
>> device which uses EIO is added?
>
> That is my intention.
Then should something like EOI cleanup be added into the commit
message for better git log searching experience? I would think the EOI
cleanup is more important then variable renaming in this patch. Or
even better to separate the changes into two patches.

>
>> Regards,
>> -Bin.
>
> Sebastian

Regards,
-Bin.

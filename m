Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab3GYPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:16:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:59597 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3GYPQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:16:55 -0400
Message-ID: <51F14165.3060803@linutronix.de>
Date: Thu, 25 Jul 2013 17:16:53 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Bin Liu <binmlist@gmail.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Subject: Re: [PATCH 06/16] usb: musb: dsps: rename ti81xx_driver_data to am33xx_driver_data
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de> <1374516607-2705-7-git-send-email-bigeasy@linutronix.de> <CADYTM3avh7GFTDQW01FnojKZkmL0_hi+=K-VVwCw5peJL2hwTA@mail.gmail.com> <20130725144118.GA5412@linutronix.de> <CADYTM3bJZKUjgddP1pddZvqg7CfVyayxEXfBoJFrhean79+ykA@mail.gmail.com>
In-Reply-To: <CADYTM3bJZKUjgddP1pddZvqg7CfVyayxEXfBoJFrhean79+ykA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 05:12 PM, Bin Liu wrote:
> Sebastian,

Hi Bin,

>> Is it really there or was it never there and it has been added to TRM by
>> accident?
> The EOI register IS in the USB subsystem of AM33xx, but the SoC does
> not use it because it uses level triggering for USB interrupt.

I see.

>>> But I am not sure if it is a good idea to remove eoi from the musb_dsps
>>> driver. If the intension is to merge the support for other SoC, such as
>>> AM35xx, AM18xx, then EOI handling might be still needed. I just don't know
>>> how those devices use EOI.
>>
>> If one of the architectures gets added which need an EOI then the offset
>> can be 0 and the EOI will happen only if it is != 0.
> This patch cleaned up the use of EOI. Do you mean EOI handling will be
> added back with condition EOI offset != 0, when the support of new
> device which uses EIO is added?

That is my intention.

> Regards,
> -Bin.

Sebastian

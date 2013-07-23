Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026Ab3GWTJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:09:56 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:58307 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933129Ab3GWTJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:09:54 -0400
MIME-Version: 1.0
In-Reply-To: <CADYTM3avh7GFTDQW01FnojKZkmL0_hi+=K-VVwCw5peJL2hwTA@mail.gmail.com>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
	<1374516607-2705-7-git-send-email-bigeasy@linutronix.de>
	<CADYTM3avh7GFTDQW01FnojKZkmL0_hi+=K-VVwCw5peJL2hwTA@mail.gmail.com>
Date: Tue, 23 Jul 2013 14:09:54 -0500
Message-ID: <CADYTM3Zagr7WQna+wmhJd+FYnk+5eAjOW8XKwi7h+J4=Pu-MGg@mail.gmail.com>
Subject: Re: [PATCH 06/16] usb: musb: dsps: rename ti81xx_driver_data to am33xx_driver_data
From: Bin Liu <binmlist@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(re-send, due to last delivery failure to the mailing list...)

On Tue, Jul 23, 2013 at 1:23 PM, Bin Liu <binmlist@gmail.com> wrote:
> Hi Sebastian,
>
> On Mon, Jul 22, 2013 at 1:09 PM, Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
>>
>> This patch renames the type struct from ti81xx_driver_data to
>> am33xx_driver_data since it is not used for ti81xx anymore. The EOI
>> member is also removed since the am33xx SoC does not have such register.
>> The interrupt is acknowledged by writting into the stat register.
>
> I guess the EOI register is removed from the TRM because AM33xx does not use
> it, there is no need to write to it to acknowledge. It does not hurt to
> write to it though since the register still exists, it just does nothing, I
> guess.
>
> But I am not sure if it is a good idea to remove eoi from the musb_dsps
> driver. If the intension is to merge the support for other SoC, such as
> AM35xx, AM18xx, then EOI handling might be still needed. I just don't know
> how those devices use EOI.
>
> Regards,
> -Bin.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbbAVKg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:36:26 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35422 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbbAVKgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:36:19 -0500
Message-ID: <54C0D29C.4010904@collabora.co.uk>
Date: Thu, 22 Jan 2015 11:36:12 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH RESEND v2 3/7] mfd: cros_ec: Add cros_ec_lpc driver for
 x86 devices
References: <1420205572-2640-1-git-send-email-javier.martinez@collabora.co.uk> <1420205572-2640-4-git-send-email-javier.martinez@collabora.co.uk> <20150120081104.GT21886@x1> <54BE7B08.1010900@collabora.co.uk> <20150120163410.GC30656@x1> <54BE87C4.4040108@collabora.co.uk> <20150122084244.GP22024@x1> <54C0BE21.7020008@collabora.co.uk> <20150122094608.GA5769@x1>
In-Reply-To: <20150122094608.GA5769@x1>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

On 01/22/2015 10:46 AM, Lee Jones wrote:
>> 
>> But there doesn't seem to be a LPC subsystem in the kernel so we don't have a
>> nice abstraction layer in this case.
> 
> This is the crux of the problem.  However, I feel bad for MFD, as it
> is, once more, being used as an "well it doesn't fit anywhere else, so
> let's shoehorn it in there" type of dumping ground.
>

Yes, I completely understand your point, is that I didn't think that a ~300
lines driver was that bad specially since the communication bits that reads
and writes the register is not a complex logic IMHO.
 
>> > Are there any other Low Pin Count drivers in the kernel?
>> >
>> 
>> I don't know tbh, I didn't even know what LPC was before I picked this patch
>> to push it upstream. I searched in the Linux codebase for other LPC drivers
>> but I didn't find anything, that doesn't mean that it doesn't exist though.
> 
> I agree.  Perhaps a suitable driver should live in drivers/misc until
> there are enough of them to warrant its own subsystem.
>

Yes, I can move the driver to drivers/misc if you think that is more suitable
to be there.

I've taken another look and AFAICT there are two other mfd drivers that use an
LPC bus, these are drivers/mfd/lpc_{i,s}ch.c for Intel's I/O Controller HUB and 
System Controller Hub respectively.

> Anyone else have an opinion?
> 

Best regards,
Javier

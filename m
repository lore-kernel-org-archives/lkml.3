Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaKRBOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 20:14:20 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36873 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbaKRBOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 20:14:18 -0500
Message-ID: <546A9D67.4010508@linaro.org>
Date: Mon, 17 Nov 2014 20:14:15 -0500
From: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]  usb: gadget: USB3 support to the legacy printer driver
References: <546A829A.8030106@linaro.org> <20141118003028.GA11280@saruman> <20141118005427.GB10271@kroah.com>
In-Reply-To: <20141118005427.GB10271@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2014 07:54 PM, Greg KH wrote:
> On Mon, Nov 17, 2014 at 06:30:28PM -0600, Felipe Balbi wrote:
>> Hi,
>>
>> On Mon, Nov 17, 2014 at 06:19:54PM -0500, Jorge Ramirez-Ortiz wrote:
>>> Hi,
>>>
>>> This patch adds USB3 support to the legacy gadget printer driver.
>>> Applies cleanly on fc14f9c Linux 3.18-rc5.
>>>
>>> Please could it be considered for inclusion?
>> sure, if you send it properly (see Documentation/SubmittingPatches),
>> provide logs of your tests with a recent kernel (v3.18-rc5 would be just
>> awesome) and Cc myself on your resubmission.
>>
>>> diff --git a/drivers/usb/gadget/legacy/printer.c b/drivers/usb/gadget/legacy/printer.c
>>> index 6474081..625d905 100644
>>> --- a/drivers/usb/gadget/legacy/printer.c
>>> +++ b/drivers/usb/gadget/legacy/printer.c
>>> @@ -3,6 +3,7 @@
>>>   *
>>>   * Copyright (C) 2003-2005 David Brownell
>>>   * Copyright (C) 2006 Craig W. Nadler
>>> + * Copyright (C) 2014 Linaro.org
>> I don't think the minimal change below constitutes enough to merit the
>> copyright. If your lawyers tell you otherwise, let me know.
>>
>> Greg, what's Linux Foundation's lawyers take on this ?
> I'm not going to speak for the Linux Foundation here (we have no
> in-house lawyers), but I have been advised that you need to modify/add
> at least 1/3 of the file before you can add your copyright notice to a
> file.  That's the rule I go by, and numerous lawyers I have asked about
> this say it is a safe rule to follow.
>
> Linaro should also be following those rules, last I checked with them,
> so Jorge, you should go back and ask for clarification.

Yes, let's drop the copyright - my fault.

>
> But then there's the issue that copyright notices in files really don't
> mean anything, but I'm not going to get into that discussion right now :)
>
> thanks,
>
> greg k-h


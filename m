Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbaGCHGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:06:49 -0400
Received: from mail01.baslerweb.com ([80.156.24.166]:4048 "EHLO
	mail01.baslerweb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaGCHGs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:06:48 -0400
Message-ID: <53B50105.1060005@baslerweb.com>
Date: Thu, 3 Jul 2014 09:06:45 +0200
From: Stefan Klug <stefan.klug@baslerweb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stern@rowland.harvard.edu>
Subject: Re: [PATCH][RFC] USB: zerocopy support for usbfs
References: <53B42B14.7010303@baslerweb.com> <20140702175526.GA21063@kroah.com>
In-Reply-To: <20140702175526.GA21063@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [172.16.50.117]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02.07.2014 19:55, Greg KH wrote:
> Very nice. 
Thanks.
> Minor non-technical issues here, your patch is corrupted (linewrapped 
> and tabs converted to spaces) and can't be applied at all. Can you fix 
> your email client and try again? Look at 
> Documentation/email_clients.txt for hints on how to do this.
Hm, I thought I checked that one. Sorry. I'll test and resend correctly.
>> --- a/drivers/usb/core/devio.c
>> +++ b/drivers/usb/core/devio.c
>> @@ -4,6 +4,7 @@
>>    *      devio.c  --  User space communication with USB devices.
>>    *
>>    *      Copyright (C) 1999-2000  Thomas Sailer (sailer@ife.ee.ethz.ch)
>> + *      Copyright (C) 2014  Stefan Klug (stefan.klug@baslerweb.com)
> According to legal advice given to me, this isn't needed / true, so can
> you drop it?  Or, if you have different legal advice, might I ask for
> what the legal justification is that this needs to be added?
No problem. I'll remove them.
>
>>    *      This program is free software; you can redistribute it and/or
>> modify
>>    *      it under the terms of the GNU General Public License as published
>> by
>> @@ -30,6 +31,7 @@
>>    *    04.01.2000   0.2   Turned into its own filesystem
>>    *    30.09.2005   0.3   Fix user-triggerable oops in async URB delivery
>>    *                 (CAN-2005-3055)
>> + *    07.05.2014   0.4   Added zerocopy support
> No need to do this, we use git now and that's where the changelog goes.
> We should just delete this "fake changelog" entirely from this file.
I'll remove the line and maybe prepare a cleanup patch later.


Stefan Klug
Software Developer

Basler AG
An der Strusbek 60-62
22926 Ahrensburg
Germany

Tel. +49 4102 463 582
Fax +49 4102 463 46 582
 
Stefan.Klug@baslerweb.com

www.baslerweb.com

Vorstand: Dr.-Ing. Dietmar Ley (Vorsitzender) · John P. Jennings · Arndt Bake · Hardy Mehl
Aufsichtsratsvorsitzender: Norbert Basler 
Basler AG · Amtsgericht Lübeck HRB 4090 · Ust-IdNr.: DE 135 098 121 · Steuer-Nr.: 30 292 04497 · WEEE-Reg.-Nr. DE 83888045

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaGHFja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 01:39:30 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:53899 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaGHFj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 01:39:29 -0400
MIME-Version: 1.0
In-Reply-To: <53BB7F3C.6050700@roeck-us.net>
References: <CAPDOMVjMpU4g5oPNHQYP2q6M-B7dxh1wPO3Nf4f=idCQcM8bfA@mail.gmail.com>
	<20140708033251.GA18777@kroah.com>
	<53BB6CF4.5010600@roeck-us.net>
	<CAPDOMVg+HGpvVYw1VAvaMFK7eXwKh-qZZfObzgzLCFtmQV3B2w@mail.gmail.com>
	<53BB78B2.1020401@roeck-us.net>
	<CAPDOMVhW1DrO+aGYLHNs1zy9BLvXU0KZg=dWrnLyPTgxneacsg@mail.gmail.com>
	<CAPDOMVjfuDmdkASHTdO9CdzZbHHoRi9ZY2VXLeb3=aPywhsfWw@mail.gmail.com>
	<CAPDOMVjqT7P1BzPiTdThUNhTQk4T7ACY2Eymy5fThfLdL-Vb4A@mail.gmail.com>
	<53BB7F3C.6050700@roeck-us.net>
Date: Tue, 8 Jul 2014 01:39:28 -0400
Message-ID: <CAPDOMVgNXFVEGjkzZdw3Wkte7T8VPgCFHgL1abq2k_==doWFwg@mail.gmail.com>
Subject: Fwd: Fwd: Fwd: shx3_defconfig Fails
From: Nick Krause <xerofoify@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>, Guenter Roeck <linux@roeck-us.net>
Cc: jslaby@suse.cz,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck wrote on Tue, Jul 8, 2014 at 1:18 AM
Subject: Re: Fwd: Fwd: shx3_defconfig Fails
To: Nick Krause <xerofoify@gmail.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: jslaby@suse.cz, "linux-kernel@vger.kernel.org"
<linux-kernel@vger.kernel.org>


On 07/07/2014 10:13 PM, Nick Krause wrote:
>
> ---------- Forwarded message ----------
> From: Nick Krause <xerofoify@gmail.com>
> Date: Tue, Jul 8, 2014 at 1:11 AM
> Subject: Fwd: Fwd: shx3_defconfig Fails
> To: linux@roeck-us.net, gregkh@linuxfoundation.org
> Cc: slaby@suse.cz
>
>
> ---------- Forwarded message ----------
> From: Nick Krause <xerofoify@gmail.com>
> Date: Tue, Jul 8, 2014 at 1:07 AM
> Subject: Fwd: Fwd: shx3_defconfig Fails
> To: linux@roeck-us.ne, Greg KH <gregkh@linuxfoundation.org>
> Cc: slaby@suse.cz, "slaby@suse.cz" <linux-kernel@vger.kernel.org>
>
>
> From: Guenter Roeck  work Tue, Jul 8, 2014 at 12:50 AM
> Subject: Re: Fwd: shx3_defconfig Fails
> To: Nick Krause <xerofoify@gmail.com>, Greg KH <gregkh@linuxfoundation.org>
> Cc: jslaby@suse.cz, "linux-kernel@vger.kernel.org"
> <linux-kernel@vger.kernel.org>
>
>
> On 07/07/2014 09:29 PM, Nick Krause wrote:
>>
>>
>> Guenter Roeck  work on Tue, Jul 8, 2014 at 12:00 AM
>> Subject: Re: shx3_defconfig Fails
>>
>> On 07/07/2014 08:32 PM, Greg KH wrote:
>>>
>>>
>>>
>>> On Mon, Jul 07, 2014 at 11:04:23PM -0400, Nick Krause wrote:
>>>>
>>>>
>>>>
>>>> Hey Greg and others,
>>>> The build, shx3_defconfig seems to be failing.
>>>
>>>
>>>
>>>
>>> In what kernel version?
>>>
>>> Has it ever worked?
>>>
>>> Why not ask the maintainer of that arch about it?  I doubt many people
>>> ever use defconfig files anymore...
>>>
>>
>> Works in mainline for me. And, for the record, I use lots of defconfig files
>> (144 or so of them) for my build tests, so there is at least one user :-)
>>
>> Cheers,
>> Guenter
>>
>> Still fails in the the same way. I am using the latest git tree.
>> Cheers Nick
>>
>
>> From your other errors I start wondering if you use dash or some other non-bash
>
> shell and some dash-incompatibility creeped into the kernel build (again).
>
> Guenter
>
> Hey Guenter,
> I seem to be using bash. Weird , maybe this is just my machine ,perhaps.


Sure, but what does /bin/sh point to ? Default on Ubuntu would be dash.

Guenter

It does point to dash , therefore I should load bash on opening a shell ,
I guess. This is probably my issue.

Thanks  Nick

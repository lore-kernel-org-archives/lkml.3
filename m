Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaGHErC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 00:47:02 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53000 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaGHErA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 00:47:00 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53BB77C2.5000908@roeck-us.net>
Date: Mon, 07 Jul 2014 21:46:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>, Greg KH <gregkh@linuxfoundation.org>
CC: jslaby@suse.cz,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: shx3_defconfig Fails
References: <CAPDOMVjMpU4g5oPNHQYP2q6M-B7dxh1wPO3Nf4f=idCQcM8bfA@mail.gmail.com>	<20140708033251.GA18777@kroah.com>	<53BB6CF4.5010600@roeck-us.net> <CAPDOMVg+HGpvVYw1VAvaMFK7eXwKh-qZZfObzgzLCFtmQV3B2w@mail.gmail.com>
In-Reply-To: <CAPDOMVg+HGpvVYw1VAvaMFK7eXwKh-qZZfObzgzLCFtmQV3B2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 09:29 PM, Nick Krause wrote:
> Guenter Roeck  work on Tue, Jul 8, 2014 at 12:00 AM
> Subject: Re: shx3_defconfig Fails
>
> On 07/07/2014 08:32 PM, Greg KH wrote:
>>
>> On Mon, Jul 07, 2014 at 11:04:23PM -0400, Nick Krause wrote:
>>>
>>> Hey Greg and others,
>>> The build, shx3_defconfig seems to be failing.
>>
>>
>> In what kernel version?
>>
>> Has it ever worked?
>>
>> Why not ask the maintainer of that arch about it?  I doubt many people
>> ever use defconfig files anymore...
>>
>
> Works in mainline for me. And, for the record, I use lots of defconfig files
> (144 or so of them) for my build tests, so there is at least one user :-)
>
> Cheers,
> Guenter
>
> Still fails in the the same way. I am using the latest git tree.

What exactly is failing for you ? The log you provided shows a bunch of
warnings and a final error, but I don't see the actual error in the log.

Guenter


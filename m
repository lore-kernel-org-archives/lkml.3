Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbaDWNiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:38:20 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61758 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbaDWNiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:38:16 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5357C246.7050604@roeck-us.net>
Date: Wed, 23 Apr 2014 06:38:14 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: monstr@monstr.eu
CC: linux-kernel@vger.kernel.org
Subject: Re: Microblaze image hanging in qemu with 3.15-rc
References: <20140422172356.GA15672@roeck-us.net> <53575074.6010602@monstr.eu>
In-Reply-To: <53575074.6010602@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 10:32 PM, Michal Simek wrote:
> Hi Guenter,
>
>
> On 04/22/2014 07:23 PM, Guenter Roeck wrote:
>> Hi all,
>>
>> when trying to run a microblaze image with 3.15-rc1 or 3.15-rc2 in qemu,
>> I get the following hangup. This used to work with earlier kernels
>> with the same configuration.
>>
>> Is this a known problem, or is something wrong with my configuration
>> or with my qemu command line ?
>
> Is this BE/LE version? Which qemu do you use?

BE.

file vmlinux:

vmlinux: ELF 32-bit MSB  executable, version 1 (SYSV), statically linked, BuildID[sha1]=5e1872c08df2956eddaed6fc1f6528a8540375b7, not stripped

qemu-system-microblaze --version:

QEMU emulator version 1.7.0, Copyright (c) 2003-2008 Fabrice Bellard

gcc --version:

microblaze-linux-gcc (GCC) 4.8.0
Copyright (C) 2013 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

> There is endian autodetection in timer and intc driver
> which can caused this problem.
>
Is this new code ? I didn't see the problem in 3.13 (same compile options,
same configuration, same compiler, same qemu version).

Thanks,
Guenter


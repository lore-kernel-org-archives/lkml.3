Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbbAEK07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:26:59 -0500
Received: from mail.windriver.com ([147.11.1.11]:58369 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbAEK04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:26:56 -0500
Message-ID: <54AA66E0.6050504@windriver.com>
Date: Mon, 5 Jan 2015 18:26:40 +0800
From: yzhu1 <Yanjun.Zhu@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>,
        =?KOI8-R?Q?=F0=CC=C1=CD=C5=CE_=F0=C5?= =?KOI8-R?Q?=D4=D2=CF=D7?= 
	<plamen@petrovi.no-ip.info>,
        <linux-kernel@vger.kernel.org>
CC: "'Thomas Gleixner'" <tglx@linutronix.de>
Subject: Re: [BISECTED] 3.19-rc1 regression - kernel does not load in GRUB
 0.97 (GRUB Legacy)
References: <000001d01f10$85f506f0$91df14d0$@petrovi.no-ip.info> <549EB88D.20403@suse.com> <000301d0226e$bb275b50$317611f0$@petrovi.no-ip.info> <549FE582.8060108@suse.com>
In-Reply-To: <549FE582.8060108@suse.com>
Content-Type: text/plain; charset="koi8-r"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.162.232]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2014 07:12 PM, Juergen Gross wrote:
> On 12/28/2014 08:20 AM, Пламен Петров wrote:
>>> -----Original Message-----
>>> From: Juergen Gross [mailto:jgross@suse.com]
>>> Sent: Saturday, December 27, 2014 3:48 PM
>>> To: Пламен Петров; linux-kernel@vger.kernel.org
>>> Cc: 'Thomas Gleixner'
>>> Subject: Re: [BISECTED] 3.19-rc1 regression - kernel does not load 
>>> in GRUB
>>> 0.97 (GRUB Legacy)
>>>
>>> On 12/24/2014 01:28 AM, Пламен Петров wrote:
>>>> Hello!
>>>>
>>>> I use GRUB Legacy bootloader (version 0.97) on a couple machines, and
>>>> where 3.18.x loads fine, 3.19-rc1 does not.
>>>>
>>>> While compiling I used the attached .config file accompanied by "make
>>>> olddefconfig"
>>>
>>> Can you tell me something about the hardware (processor model)?
>>> You are not booting the system under VMWare by any chance?
>>
>> As a matter of fact - I am compiling in a VMware Player (6.0.3
>> build-1895310) virtual machine, boot testing there, and then if 
>> everything
>> is OK, I transfer the monolithic kernel produced on 3 virtual 
>> machines that
>> run on EXSi and 2 actual servers. So along those lines - the failing
>> 3.19-rc1 never saw actual hardware - it was all tested (and bisected) 
>> inside
>> a VM.
>
> Thanks. VMWare having problems with my patch is a known issue. I've
> already sent a patch working around that issue (VMWare has a bug
> emulating the PAT MSR). You can either use that patch (attached for
> your convenience) or use the "nopat" option.
>
>
> Juergen
>
This patch works for me. I made tests with this patch.

Zhu Yanjun

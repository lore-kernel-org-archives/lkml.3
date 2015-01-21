Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbbAUO3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:29:18 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:39953 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbbAUO3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:29:09 -0500
Message-ID: <54BFB7B1.5000908@gmail.com>
Date: Wed, 21 Jan 2015 15:29:05 +0100
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Jeremy Newton <alexjnewt@hotmail.com>, Thomas Koch <linrunner@gmx.net>,
        =?windows-1252?Q?Andr=E9_Erdmann?= <dywi@mailerd.de>,
        =?windows-1252?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: Uhhuh - Dazed and confused, but trying to continue  :)
References: <54BB8FFE.5010308@gmail.com> <20150119134942.GH116159@redhat.com> <54BF6AEC.5090706@gmail.com> <20150121142423.GC116159@redhat.com>
In-Reply-To: <20150121142423.GC116159@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.01.2015 15:24, Don Zickus wrote:
> On Wed, Jan 21, 2015 at 10:01:32AM +0100, poma wrote:
>> On 19.01.2015 14:49, Don Zickus wrote:
>>
>> Thank you, in the meantime, I've found what causes non-maskable interrupt, [23]d on CPU 0, on resuming S4,
>> on AMD Phenom(tm) II X4 955 Processor.
>>
>> /etc/default/tlp
>> ...
>> # Kernel NMI Watchdog
>> # 0=disable (default, saves power) / 1=enable (for kernel debugging only)
>> NMI_WATCHDOG=0
>>
>> Toggling to 1, messages no longer appear,
>> NMI_WATCHDOG=1
>>
>> $ cat /proc/sys/kernel/nmi_watchdog
>> 1
>> $ sysctl kernel.watchdog
>> kernel.watchdog = 1
>>
>> Isn't it brilliant.
> 
> 
> Hehe.  Ok.  All that does is swallow your unknown NMI.  But if that makes
> you happy, I am fine with that. :-)
> 
> Cheers,
> Don
> 

I don't want to bother you for nothing, as long as nothing crashes, it can pass.
Thanks again.



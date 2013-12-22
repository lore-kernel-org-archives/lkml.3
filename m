Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab3LVWTh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 17:19:37 -0500
Received: from imp02.mtu.ru ([62.5.255.19]:56655 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438Ab3LVWTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 17:19:35 -0500
X-Spam-Flag: NO
Message-ID: <52B76562.7040608@pavlinux.ru>
Date: Mon, 23 Dec 2013 02:19:14 +0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131118 Thunderbird/17.0.11
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.12.5 CRASH/FREEZE
References: <52A9CC77.20904@linaro.org> <52AA1CC0.30307@pavlinux.ru> <20131220141008.GE10249@linutronix.de> <52B45AEB.2060508@pavlinux.ru> <52B45CD7.5030404@linutronix.de>
In-Reply-To: <52B45CD7.5030404@linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-STREAM-Metrics: ss27-so03.mtu.ru 10003; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

20.12.2013 19:05, Sebastian Andrzej Siewior пишет:
> On 12/20/2013 03:57 PM, Pavel Vasilyev wrote:
>>
>> Same bug if attach to ehci hub.
>>
>> ksoftird/0 process of loading the CPU upto 100% Sometimes process
>> irq17/0 - ehci_hcd  or xhci_hcd. After taking the camera out of the
>> socket, the load does not fall, keyboard and console blocked
> 
> Okay, but this problem is unique to your webcam. Keyboard & mice to
> work as usual?
> Could please provide me the addr2line either for the ehci or xhci? I've
> been browsing to the code and I didn't see anything obvious.
> 

Too many bugs, too many computers ...

3.12.5-rt7 work ONLY in UP-mode!!! cmdline: nosmp maxcpus=1

In SMP mode, problems arise in different places on different computers.
On Intel Atom - USB, webcam and console. On the Opteron 285 system
does not boot, can't mount devtmpfs, XFS partitions ...

I can not get to catch the error and find a place neither in debug mode or in
normal. Because everything is frozen completely, and get to the console or logs
is not possible.
I described one situation where had run top and see that the process
ksoftirqd/0 use CPU upto 100%

P.S.
    3.12.5-rt7 still work Basic-RT mode.






-- 

                                                         Pavel.

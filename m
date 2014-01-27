Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaA0FV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 00:21:56 -0500
Received: from toro.web-alm.net ([62.245.132.31]:48506 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbaA0FVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 00:21:55 -0500
X-Greylist: delayed 1176 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jan 2014 00:21:54 EST
Message-ID: <52E5E687.1090808@osadl.org>
Date: Mon, 27 Jan 2014 05:54:31 +0100
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.8-rt11
References: <20140125134519.GA9845@linutronix.de>
In-Reply-To: <20140125134519.GA9845@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2014 02:45 PM, Sebastian Andrzej Siewior wrote:
> Dear RT folks!
>
> I'm pleased to announce the v3.12.8-rt11 patch set.
> [..]
Thanks a lot, Sebastian, excellent work!

I have upgraded about 40 different QA Farm systems (x86: 32-bit, 64-bit, 
single-core, multi-core 2 to 32, single-socket, dual-socket; ARM: 
single-core, multi-core), and they all boot and run without any problem. 
I didn't see any crash of unknown origin so far. Most systems use the 
original kernel besides some unimportant farm patches. Several systems 
have a worst-case latency below 20 microseconds (e.g. 
https://www.osadl.org/?id=1420 and https://www.osadl.org/?id=1805). Even 
Raspberry Pi and BeagleBone-Black work like a charm and have reasonably 
low real-time latency (https://www.osadl.org/?id=1663 and 
https://www.osadl.org/?id=1601), although they still are not 100% 
mainline. It is well conceivable that this or one of the next 3.12.X-rtY 
versions will remind us of the legendary 2.6.33 RT kernel.

Seems that an important milestone is being reached.

Thanks,
	-Carsten.

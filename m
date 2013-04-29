Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab3D2PqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 11:46:22 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:44905 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757256Ab3D2PqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 11:46:20 -0400
Message-ID: <517E95CA.4000708@newflow.co.uk>
Date: Mon, 29 Apr 2013 16:46:18 +0100
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        tglx@linutronix.de, lkml <linux-kernel@vger.kernel.org>
Subject: Re: v3.9.0-rc8 : oops in tick_do_update_jiffies64+0xbc/0x110
References: <517E3039.2070204@newflow.co.uk> <20130429154146.GB28721@atomide.com>
In-Reply-To: <20130429154146.GB28721@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/04/13 16:41, Tony Lindgren wrote:
> * Mark Jackson <mpfj-list@newflow.co.uk> [130429 01:38]:
>> I've been experiencing several crashes all pointing exactly the same place in the same tick routine (see below).
>>
>> The "exception stack" trace at the end changes depending on when the oops occurs.
>>
>> I've had the oops occur maybe 6 times in the last 50 reboots.
>>
>> Any ideas ?
> 
> Sounds like it might be an issue with the physical memory or
> the timings. It could also be related to the idle loop not
> restoring something right for deeper idle states that corrupts
> the memory. And that's why it would seem to appear while waking
> to a timer.

I am suspecting a borderline CPU.  We only have "X" AM3359 parts which
are all pre-production.

> Maybe disable PM and run memtester to see if that runs reliably?

I'll see if I can get it running on our platform.

Thanks
Mark J.

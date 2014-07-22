Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbaGVRGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 13:06:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57582 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbaGVRGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 13:06:19 -0400
Message-ID: <53CE99C9.30506@zytor.com>
Date: Tue, 22 Jul 2014 10:05:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Bruno Wolff III <bruno@wolff.to>
CC: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Scheduler regression from caffcdd8d27ba78730d5540396ce72ad022aff2c
References: <20140718141648.GE20603@laptop.programming.kicks-ass.net> <20140718145040.GG12054@laptop.lan> <20140718161602.GH12054@laptop.lan> <20140721163528.GA10433@wolff.to> <20140721165212.GO3935@laptop> <20140722094740.GJ12054@laptop.lan> <20140722103857.GK12054@laptop.lan> <20140722121001.GA30631@wolff.to> <20140722130343.GD3935@laptop> <20140722132603.GL12054@laptop.lan> <20140722133514.GM12054@laptop.lan>
In-Reply-To: <20140722133514.GM12054@laptop.lan>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 06:35 AM, Peter Zijlstra wrote:
> On Tue, Jul 22, 2014 at 03:26:03PM +0200, Peter Zijlstra wrote:
>> On Tue, Jul 22, 2014 at 03:03:43PM +0200, Peter Zijlstra wrote:
>>> Oh, of course we do SMP detection and setup after the cache setup...
>>> lovely.
>>>
>>> /me goes bang head against wall
>>
>> hpa, could we move the legacy cpuid1/cpuid4 topology detection muck up,
>> preferably right after detect_extended_topology()?
>>
>> I need c->phys_proc_id in init_intel_cacheinfo() for machines with
>> cpuid_level < 4.
> 
> Something like so.. anything obviously broken?
> 

Nothing *obvious*.  I should stare a pass at the code.

	-hpa



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049AbaBBBZr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 20:25:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37382 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbaBBBZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 20:25:45 -0500
Message-ID: <52ED9E7E.6090205@zytor.com>
Date: Sat, 01 Feb 2014 17:25:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>, torvalds@linux-foundation.org
CC: jack@suse.cz, linux-kernel@vger.kernel.org, maarten-baert@hotmail.com,
        mingo@kernel.org, nate@thatsmathematics.com, priikone@iki.fi,
        sbsiddha@gmail.com, stable@vger.kernel.org, tglx@linutronix.de,
        x86@kernel.org
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt
 flag
References: <20140202011931.27901.qmail@science.horizon.com>
In-Reply-To: <20140202011931.27901.qmail@science.horizon.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2014 05:19 PM, George Spelvin wrote:
>> OK, let's circle back for a bit.  We have an active bug, and we clearly
>> have a lot of restructuring that could/should be done.  We need to fix
>> the bug first; if we're going to a bunch of restructuring then that
>> ought to be separate.  The first bit is how we fix the immediate bug.
> 
> Well, that's what the [PATCH] that started this thread,s for which seems
> to greatly reduce the incidence.
> 
> The issue being discussed here is the fact that it's far from clear to
> people that the result of applying that patch is actually bug-free.
> 
> Given how long it's been in shipping kernels (2.6.26 or 3.10, depending
> on what you think causes it to trigger) and how few complaints there
> have been, I'm happy to take a while to think about it.
> 

Yes, I would agree with that.  I guess I should have said "how do we fix
the immediate bug(s) properly."

	-hpa


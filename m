Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaDURu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 13:50:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33351 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaDURuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 13:50:25 -0400
Message-ID: <53555A5F.4040500@infradead.org>
Date: Mon, 21 Apr 2014 10:50:23 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ryan Nicholl <r.p.nicholl@gmail.com>, linux-kernel@vger.kernel.org
CC: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Futex Question (64 bits?)
References: <CAPuLQKxoc3Gk3_xKetSOzFLg5s36P3MJ7Jy=15_JmwYp2J_v+g@mail.gmail.com>
In-Reply-To: <CAPuLQKxoc3Gk3_xKetSOzFLg5s36P3MJ7Jy=15_JmwYp2J_v+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding Rusty]

On 03/24/2014 02:19 PM, Ryan Nicholl wrote:
> I would like to know if it would be possible to use a 64 bit futex
> call? If not, I would like to request it be added. (It is acknowledged
> in the manpages that it must be added eventually anyway.)
> 
> I am programming a C++11+ library. One of the constructed features is
> a "locking pointer". Unfortunately, pointers are usually 64 bits,
> while the futex call supports only 32 bits. I could not discover any
> documented way to invoke a 64 bit futex call.
> 
> It's unfortunate in that the futex call must have a timeout set
> because of the possible deadlock condition where only the half of the
> pointer not futexed is modified between the time the system call is
> entered and executed.
> 
> This creates a situation that prevents the locking_ptr from being
> realtime safe unless the timeout is set at a very low value.
> Furthermore, this causes excess CPU usage due to spurious wakeups.
> 
> Thank you,
> Ryan Nicholl
> --



-- 
~Randy

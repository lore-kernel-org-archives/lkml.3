Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750996AbaBBBTf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 20:19:35 -0500
Received: from science.horizon.com ([71.41.210.146]:43340 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750843AbaBBBTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 20:19:34 -0500
Date: 1 Feb 2014 20:19:31 -0500
Message-ID: <20140202011931.27901.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: hpa@zytor.com, linux@horizon.com, torvalds@linux-foundation.org
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt flag
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, maarten-baert@hotmail.com,
        mingo@kernel.org, nate@thatsmathematics.com, priikone@iki.fi,
        sbsiddha@gmail.com, stable@vger.kernel.org, tglx@linutronix.de,
        x86@kernel.org
In-Reply-To: <52ED85DD.6020402@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, let's circle back for a bit.  We have an active bug, and we clearly
> have a lot of restructuring that could/should be done.  We need to fix
> the bug first; if we're going to a bunch of restructuring then that
> ought to be separate.  The first bit is how we fix the immediate bug.

Well, that's what the [PATCH] that started this thread,s for which seems
to greatly reduce the incidence.

The issue being discussed here is the fact that it's far from clear to
people that the result of applying that patch is actually bug-free.

Given how long it's been in shipping kernels (2.6.26 or 3.10, depending
on what you think causes it to trigger) and how few complaints there
have been, I'm happy to take a while to think about it.

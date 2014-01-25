Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaAYVfD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 16:35:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57318 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaAYVfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 16:35:00 -0500
Message-ID: <1390685686.5522.21.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.12.8-rt11
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Sat, 25 Jan 2014 22:34:46 +0100
In-Reply-To: <20140125134519.GA9845@linutronix.de>
References: <20140125134519.GA9845@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:N74lBdLL1s8s7+ojs4GJ2XwAJVUHY4R4s2iEE9p4Qzz
 +w6BD6x4k5PxCBrJFDzG/+i4CeFPHY6y6ypmumn/wYqOzHDlc3
 qYi4kkvfp6534nMXMIJhKpZBR9p+SApVvIBegh8jksxzSMuwSc
 G9KNn2uu0LuLuOmTL6JG8PxC1X5HJ32a1r0Q8IW5tgxK7h34vP
 y9zmPt+Ggi75WT2OVPMGU+aZezrx0jBBiaO5Pf+6mDxsuAzY7D
 XW9y4HvpdVRHlhCXuvRAPw9Wtb1poHZ8SwMc+BpaSb3tnI88pb
 gZnLydseVzqW+p7rltbKRBFJpbjvx2f1UPLsWeZV0T/DvmoBWx
 SspYLqLpyKIKkSZhSS5MV/EROlVzLr6yc5Oh5TJ21aNkPtDK+Q
 Y4l/Osf5qq3cQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-01-25 at 14:45 +0100, Sebastian Andrzej Siewior wrote: 
> Dear RT folks!
> 
> I'm pleased to announce the v3.12.8-rt11 patch set.
> 
> Changes since v3.12.8-rt10
> - The "do not to raise the timer softirq unconditionally" resulted a few
>   boot lockups on a few boxes. Steven found the problem and sent a fix.
>   Thank you Steven.

That fix _appears_ to have fixed up the runtime lockups I was hitting on
64 core box as well.  I don't have nohz_full enabled atm, but the nmi
watchdog was reliably barking either way, and while box could remain up
for quite a while, it should have died by now.  I'll let it grind away
for the rest of the weekend.

-Mike


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739AbaLDRZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:25:55 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:54754 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164AbaLDRZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:25:54 -0500
Message-ID: <5480991f.c42ee00a.3e08.ffff8ddd@mx.google.com>
Date: Thu, 4 Dec 2014 15:25:46 -0200
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Chris Rorvick <chris@rorvick.com>, Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <20141204165203.GA3916@lerouge>
References: <547e11fa.8778e00a.3439.ffffa88c@mx.google.com>
	<20141202205636.GQ25340@linux.vnet.ibm.com>
	<547e36d1.c54ae00a.2571.fffffd13@mx.google.com>
	<CA+55aFxdZjJprk8t9NxcZmewAAQ5Gf1XQWV=5i+Vfc5uTSfWFg@mail.gmail.com>
	<547e81ce.a1628c0a.4985.ffffb12a@mx.google.com>
	<CA+55aFxumSXif01LigHBgZeXFTWT-7knX=a8LJZeaZZDPoHCBg@mail.gmail.com>
	<CAEUsAPYthwHxopuiBcGg4_nnBDDsS2jrTw4pDFiov38awsFodA@mail.gmail.com>
	<CA+55aFyBgyRS0zeE+LuHAvc=54v0de2KX=hRnr3imXwFFbftXw@mail.gmail.com>
	<54801ea9.0ca5e00a.3c72.08ce@mx.google.com>
	<CA+55aFzJ2uOxHC8y25oTzkURPcXo9r=5cvcCzSxgOSKnET5voQ@mail.gmail.com>
	<20141204165203.GA3916@lerouge>
Organization: http://www.youtube.com/DanielFragaBR
X-Mailer: Claws Mail 3.11.1-9-g1f531c (GTK+ 2.24.25; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2014 17:52:08 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> And this bug has been fixed upstream with:
> 
>      _ nohz: nohz full depends on irq work self IPI support
>      _ x86: Tell irq work about self IPI support
>      _ irq_work: Force raised irq work to run on irq work interrupt
>      _ nohz: Move nohz full init call to tick init
> 
> These patches have been backported to stable as well.
> 
> I suspect Daniel rewinded far enough to fall on that old bug.
> 
> Daniel, did you see the above very stacktrace in latest upstream too? Or was it
> a different one?

	You're completely right Frederic. I was so obsessed with v3.17
that I forgot to check the fixes made after v3.17 (shame on me!).

	The revert patch Linus provided fixes the issue with v3.17, but
since Frederic just confirmed it was fixed after v3.17, then it doesn't
matter anymore.

	Sorry about that Linus. Well, so I'm using 3.18.0-rc7 and
everything is working perfect here. :)

	Thank you.

-- 
Linux 3.18.0-rc7: Diseased Newt
http://www.youtube.com/DanielFragaBR
http://exchangewar.info
Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL

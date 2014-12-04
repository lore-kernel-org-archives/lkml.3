Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbaLDSHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:07:33 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:65385 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932811AbaLDSHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:07:32 -0500
Message-ID: <5480a2e1.515d8c0a.8ed2.ffff950c@mx.google.com>
Date: Thu, 4 Dec 2014 16:07:24 -0200
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Chris Rorvick <chris@rorvick.com>, Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <CA+55aFzVqveEeVc9v58nVhCbbxh3ekV+sBjffSXLak6S9y9WCw@mail.gmail.com>
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
	<5480991f.c42ee00a.3e08.ffff8ddd@mx.google.com>
	<CA+55aFzVqveEeVc9v58nVhCbbxh3ekV+sBjffSXLak6S9y9WCw@mail.gmail.com>
Organization: http://www.youtube.com/DanielFragaBR
X-Mailer: Claws Mail 3.11.1-9-g1f531c (GTK+ 2.24.25; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2014 09:47:53 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Ok. Can you make sure to really beat on that kernel, just to make sure
> there's nothing else hiding?

	Yes, I'll keep torturing this kernel. If I find something, I'll
report here, but so far, no problem at all.

-- 
Linux 3.18.0-rc7: Diseased Newt
http://www.youtube.com/DanielFragaBR
http://exchangewar.info
Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL

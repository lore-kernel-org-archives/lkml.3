Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab3FRHOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 03:14:22 -0400
Received: from mout.gmx.net ([212.227.15.15]:64523 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab3FRHOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 03:14:21 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19efT0XZnNeRaWviUsN9gPDwjlDmDxt6dwCM1r3dt
	WjDlt7V+ghIHG1
Message-ID: <1371539652.6091.91.camel@marge.simpson.net>
Subject: Re: [PATCH 0/6] ipc/sem.c: performance improvements, FIFO
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Jun 2013 09:14:12 +0200
In-Reply-To: <1371538123.6091.87.camel@marge.simpson.net>
References: <1370884611-3861-1-git-send-email-manfred@colorfullife.com>
	 <51BB38FA.6080607@colorfullife.com>
	 <1371236750.5796.54.camel@marge.simpson.net>
	 <51BC4B99.4050506@colorfullife.com>
	 <1371538123.6091.87.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-18 at 08:48 +0200, Mike Galbraith wrote: 
> On Sat, 2013-06-15 at 13:10 +0200, Manfred Spraul wrote: 

P.S.

> > My current guess:
> > sem_lock() somehow ends up in lock_array.

Tracing shows that happens precisely one time, at end of benchmark.

-Mike


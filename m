Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab3EVMJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:09:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40729 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab3EVMJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:09:31 -0400
Date: Wed, 22 May 2013 14:07:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu, linux-media@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH v3 2/3] mutex: add support for wound/wait style locks, v3
Message-ID: <20130522120732.GA17463@dyad.programming.kicks-ass.net>
References: <20130428165914.17075.57751.stgit@patser>
 <20130428170407.17075.80082.stgit@patser>
 <20130430191422.GA5763@phenom.ffwll.local>
 <519CA976.9000109@canonical.com>
 <20130522113736.GO18810@twins.programming.kicks-ass.net>
 <519CB05E.3060903@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519CB05E.3060903@canonical.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 01:47:42PM +0200, Maarten Lankhorst wrote:
> Op 22-05-13 13:37, Peter Zijlstra schreef:
> >> Are there any issues left? I included the patch you wrote for injecting -EDEADLK too
> >> in my tree. The overwhelming silence makes me think there are either none, or
> >> nobody cared enough to review it. :(
> > It didn't manage to reach my inbox it seems,.. I can only find a debug
> > patch in this thread.
> >
> Odd, maybe in your spam folder?

Couldn't spot it there either.. weird.

> It arrived on all mailing lists,

I should both clean up my one huge lkml maildir and hack notmuch into
submission so I can read LKML again :/

> so I have no idea why you were left out.
> 
> http://www.spinics.net/lists/linux-arch/msg21425.html

Thanks, I'll go stare at it.

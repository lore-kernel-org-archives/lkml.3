Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbaIXQyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:54:33 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41159 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753839AbaIXQy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:54:29 -0400
Date: Wed, 24 Sep 2014 17:54:06 +0100
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/20] arch atomic 'cleanup'
Message-ID: <20140924165405.GJ16244@arm.com>
References: <20140508135840.956784204@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508135840.956784204@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Thu, May 08, 2014 at 02:58:40PM +0100, Peter Zijlstra wrote:
> This series continues the arch atomic rework started with the smp_mb__
> interface cleanup.
> 
> In this series we (mostly) reduce the atomic implementations by eliminating
> repetition through use of CPP macros.
> 
> A future series will use these macros to implement more atomic ops. With these
> macros we can end up with more atomic ops while the total LoC still shrinks.
> 
> Furthermore, rewrite the asm-generic/atomic implementations to require less and
> provide more.
> 
> This series is compile tested on a number of archs, but only boot tested on
> x86_64.

What's the status on this series? I'm currently fleshing out an extension to
the atomic API that allows more flexible acquire/release semantics and it
doesn't make sense for me to copy-paste a bunch of code when I could build
it on top of this instead.

Also, do you have any other patches pending in this area? I've lost track...

Cheers,

Will

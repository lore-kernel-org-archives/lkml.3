Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbaEIIOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:14:52 -0400
Received: from bastet.se.axis.com ([195.60.68.11]:34841 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbaEIIOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:14:48 -0400
Date: Fri, 9 May 2014 10:14:40 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Miller <davem@davemloft.net>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Jesper Nilsson <jespern@axis.com>, Mikael Starvik <starvik@axis.com>
Subject: Re: [PATCH 07/20] arch,cris: Fold atomic_ops
Message-ID: <20140509081440.GP9831@axis.com>
References: <20140508135852.104572724@infradead.org>
 <CAMuHMdV7FUC+p5XqwLZmqJRLYv1qhu5hf0M_e5pASBRHgFAhCA@mail.gmail.com>
 <20140508160606.GD30445@twins.programming.kicks-ass.net>
 <20140508.133451.1383193780216133211.davem@davemloft.net>
 <20140508181734.GK2844@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508181734.GK2844@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 08:17:34PM +0200, Peter Zijlstra wrote:
> On Thu, May 08, 2014 at 01:34:51PM -0400, David Miller wrote:
> > You did this for sparc too.
> 
> I did indeed.
> 
> And sparc32 and sparc64 compile file without these spurious hunks.
> 
> I'm sure I needed that to make it compile at one point, but I suspect
> they're remnants from the smp_mb__ shuffle which needed include file
> changes.
> 
> But since then I've redone those and solved the compile issues
> differently, but these hunks stuck around...
> 
> I've gone over the other patches, cris and sparc appear to be the only
> ones so affected.

With those changes, here's my

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbaJOULi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:11:38 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:55851 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaJOULh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:11:37 -0400
Date: Wed, 15 Oct 2014 23:11:34 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
In-Reply-To: <20141015.143624.941838991598108211.davem@davemloft.net>
Message-ID: <alpine.LRH.2.11.1410152310080.11974@adalberg.ut.ee>
References: <alpine.LRH.2.11.1410150012001.11850@adalberg.ut.ee> <20141014.173246.921084057467310731.davem@davemloft.net> <alpine.LRH.2.11.1410151059520.8050@adalberg.ut.ee> <20141015.143624.941838991598108211.davem@davemloft.net>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> The gcc-4.9 case is interesting, are you saying that a gcc-4.9 compiled
> >> kernel works fine on other systems?
> > 
> > Yes, all USII based systems work fine with Debian gcc-4.9, as does 
> > T2000. Of USIII* systems, V210 and V440 exhibit the boot hang with 
> > gcc-4.9 and V480 crashes wit FATAL exception during boot that is 
> > probably earlier than the gcc boot hang so I do not know about V480 and 
> > gcc-4.9. V240 not tested because of fan failures, V245 is in the queue 
> > for setup but not tested so far.
> 
> Ok, on the V210/V440 can you boot with "-p" on the kernel boot command
> line and post the log?  Let's start by seeing how far it gets, maybe
> we can figure out roughly where it dies.

http://www.spinics.net/lists/sparclinux/msg12238.html and 
http://www.spinics.net/lists/sparclinux/msg12468.html are my relevant 
posts about it. Should I get something more? It would be easy because of 
ALOM.

-- 
Meelis Roos (mroos@linux.ee)

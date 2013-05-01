Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680Ab3EAKKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 06:10:51 -0400
Received: from one.firstfloor.org ([193.170.194.197]:59897 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab3EAKKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 06:10:42 -0400
Date: Wed, 1 May 2013 12:10:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Your action on perf bug report is requested was Re: Basic perf PMU
 support for Haswell v11
Message-ID: <20130501101041.GG17814@two.firstfloor.org>
References: <1366484783-15613-1-git-send-email-andi@firstfloor.org>
 <20130426065503.GA31197@gmail.com>
 <20130426225235.GI16732@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426225235.GI16732@two.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I found a similar system (not same stepping, but same model) and tested
> perf top works fine here. Also on a couple of other systems.
> 
> Since I cannot reproduce I would need your help debugging it.

Ingo, I haven't heard back from you on this. 

You reported an unreproducable bug. I gave you several steps to
diagnose the problem, so that we can make progress on this.

You've had several days time now to to this, but I have not 
heard from you.

If you don't report back from 5/3/2013 I'll assume it was some
other mistake on your side.

As a reminder:

I assume it worked before my patches.  If you don't know
please double check. Also I assume there's no general
problem between the user land perf you used and the kernel.

The only patch I could think of which may affect other systems
is the moving of the APIC ack.

So does it work if you revert

 perf, x86: Move NMI clearing to end of PMI handler after ...

 If that is it we could white list it for Haswell.

If that's not it I may need a bisect, assuming the problem is stable.

Thanks for your cooperation.

-Andi

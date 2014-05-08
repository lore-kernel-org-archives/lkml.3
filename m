Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbaEHU1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:27:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58896 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbaEHU1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:27:33 -0400
Date: Thu, 08 May 2014 16:27:27 -0400 (EDT)
Message-Id: <20140508.162727.659734236303332635.davem@davemloft.net>
To: peterz@infradead.org
Cc: geert@linux-m68k.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, mingo@kernel.org, will.deacon@arm.com,
        paulmck@linux.vnet.ibm.com, jesper.nilsson@axis.com, starvik@axis.com
Subject: Re: [PATCH 07/20] arch,cris: Fold atomic_ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140508181734.GK2844@laptop.programming.kicks-ass.net>
References: <20140508160606.GD30445@twins.programming.kicks-ass.net>
	<20140508.133451.1383193780216133211.davem@davemloft.net>
	<20140508181734.GK2844@laptop.programming.kicks-ass.net>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 May 2014 13:27:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 8 May 2014 20:17:34 +0200

> On Thu, May 08, 2014 at 01:34:51PM -0400, David Miller wrote:
>> You did this for sparc too.
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
> 
> Just to make sure; these two hunks just went into the bit-bucket:

Thanks, with those changes:

Acked-by: David S. Miller <davem@davemloft.net>

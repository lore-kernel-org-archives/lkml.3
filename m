Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab3JVSio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 14:38:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58665 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab3JVSim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 14:38:42 -0400
Date: Tue, 22 Oct 2013 14:38:39 -0400 (EDT)
Message-Id: <20131022.143839.2085832416728125724.davem@davemloft.net>
To: sebastian@breakpoint.cc
Cc: andi@firstfloor.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, ak@linux.intel.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: wan: sbni: remove assembly crc32 code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131022183625.GA4382@breakpoint.cc>
References: <1382458346-24811-12-git-send-email-andi@firstfloor.org>
	<20131022.135928.2040131908206663695.davem@davemloft.net>
	<20131022183625.GA4382@breakpoint.cc>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 22 Oct 2013 11:38:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Date: Tue, 22 Oct 2013 20:36:25 +0200

> 
> There is also a C function doing the same thing. Unless the asm code is
> 110% faster we could stick to the C function.
> 
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> ---
> 
> On Tue, Oct 22, 2013 at 01:59:28PM -0400, David Miller wrote:
>> 
>> Is it really impossible to use the generic crc32 support instead of this
>> unsightly custom inline assembler?
> 
> Since you asked for this here step 1.

If it's that simple, this is definitely what we should do.

On the off chance, is there anyone actually able to test this
change? :-)))

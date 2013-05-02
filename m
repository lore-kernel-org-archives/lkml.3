Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3EBIti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:49:38 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:60451 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab3EBItc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:49:32 -0400
Date: Thu, 2 May 2013 10:49:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: Basic perf PMU support for Haswell v11
Message-ID: <20130502084928.GA27847@gmail.com>
References: <1366484783-15613-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366484783-15613-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> v11: Rebase to perf/core. Fix extra regs. Rename INTX.

Actually, you did not do what I asked you to do, to rename INTX to IN_TX, 
you still kept the 'INTX' pattern that is confusingly similar to 
interrupts related names like 'INT3'.

I still see, even your latest patch, this:

 +#define HSW_INTX                                       (1ULL << 32)
 +#define HSW_INTX_CHECKPOINTED                          (1ULL << 33)

Why are you ignoring maintainer requests, repeatedly?

It woulnd't be a big issue and I'd do the rename myself if this wasn't a 
repeat pattern of passive-aggressive obstruction from you spanning several 
years, resisting or obstructing maintainer feedback whenever you can ...

Thanks,

	Ingo

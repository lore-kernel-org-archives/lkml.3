Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750996Ab3LKUS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 15:18:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41168 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab3LKUSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 15:18:25 -0500
Date: Wed, 11 Dec 2013 21:18:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: perf: hsw model numbers
Message-ID: <20131211201820.GD2480@laptop.programming.kicks-ass.net>
References: <20131211103631.GJ13532@twins.programming.kicks-ass.net>
 <20131211185310.GJ21717@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211185310.GJ21717@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 07:53:10PM +0100, Andi Kleen wrote:
> > Can you add comments with each model number describing what actual part
> > it is?
> 
> It would probably be confusing, they have lots of different marketing
> names :/ Just think of them as some flavour of Haswell.

So they're all 'client' chips? Why do they have different model numbers
then?

> > 
> > Also, we seem to lack snb/ivb EX part numbers, are those already known?
> 
> They are the same as respective EP (and there is no SNB-EX)

Urgh, so we cannot differentiate between EP/EX anymore? Does that mean
that the EP chips can be used in 4-8 socket systems?


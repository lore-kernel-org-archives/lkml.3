Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab3LKLYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:24:22 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54898 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab3LKLYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:24:21 -0500
Date: Wed, 11 Dec 2013 12:24:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: andi@firstfloor.org, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: perf: hsw model numbers
Message-ID: <20131211112414.GA22034@pd.tnic>
References: <20131211103631.GJ13532@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131211103631.GJ13532@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 11:36:31AM +0100, Peter Zijlstra wrote:
> Hi Andi,
> 
> arch/x86/kernel/cpu/perf_event_intel.c
> 
> 3a632cb229bfb (Andi Kleen       2013-06-17 17:36:48 -0700 2500)         case 60: /* Haswell Client */
> 3a632cb229bfb (Andi Kleen       2013-06-17 17:36:48 -0700 2501)         case 70:
> 3a632cb229bfb (Andi Kleen       2013-06-17 17:36:48 -0700 2502)         case 71:
> 3a632cb229bfb (Andi Kleen       2013-06-17 17:36:48 -0700 2503)         case 63:
> 0499bd867bd17 (Andi Kleen       2013-08-08 17:26:23 -0700 2504)         case 69:
> 
> Can you add comments with each model number describing what actual part
> it is?
> 
> Also, we seem to lack snb/ivb EX part numbers, are those already known?

Yeah, it would be nice if Intel generally documented that whole model
mapping somewhere. For example, I spent some serious time grepping and
searching the net what family 6, model 47 actually is.

I asked hpa at some point about such doc and he said, CPUID doc needs to
get updated.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

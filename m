Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016AbaJCXUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:20:15 -0400
Received: from one.firstfloor.org ([193.170.194.197]:46694 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758596AbaJCXUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 19:20:11 -0400
Date: Sat, 4 Oct 2014 01:20:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
        dave@sr71.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        eranian@google.com, x86@kernel.org
Subject: Re: [PATCH 1/2] Use faster check for modules in backtrace on 64bit
Message-ID: <20141003232008.GF12538@two.firstfloor.org>
References: <1411774277-4198-1-git-send-email-andi@firstfloor.org>
 <1411774277-4198-2-git-send-email-andi@firstfloor.org>
 <20140929114212.GG5430@worktop>
 <20140929152145.GB1629@tassilo.jf.intel.com>
 <20140929203023.GA8196@two.firstfloor.org>
 <20140930085814.GS5430@worktop>
 <20140930200959.GB8196@two.firstfloor.org>
 <20141002105734.GD2849@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002105734.GD2849@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If you think I'm wrong please show working code.
> 
> That is unrelated to the above, you're just not willing to work on it.

I'm willing to work on practical suggestions, which this one is not.

Speculative data structure research is not on my general agenda,
and should not be required for Linx contributions.

> But the biggest issue is that its x86_64 only.

Fair enough. I'll look into something that works there too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

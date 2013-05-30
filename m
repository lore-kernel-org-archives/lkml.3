Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967625Ab3E3GcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 02:32:17 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:40441 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967568Ab3E3GcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 02:32:10 -0400
Date: Thu, 30 May 2013 08:32:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Peter Zijlstra <peterz@infradead.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, roland@kernel.org,
        infinipath@qlogic.com, linux-mm@kvack.org, linux-rdma@vger.kernel.org,
        Or Gerlitz <or.gerlitz@gmail.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [RFC][PATCH] mm: Fix RLIMIT_MEMLOCK
Message-ID: <20130530063205.GA5310@gmail.com>
References: <20130523152458.GD23650@twins.programming.kicks-ass.net>
 <0000013ed2297ba8-467d474a-7068-45b3-9fa3-82641e6aa363-000000@email.amazonses.com>
 <20130523163901.GG23650@twins.programming.kicks-ass.net>
 <0000013ed28b638a-066d7dc7-b590-49f8-9423-badb9537b8b6-000000@email.amazonses.com>
 <20130524140114.GK23650@twins.programming.kicks-ass.net>
 <0000013ed732b615-748f574f-ccb8-4de7-bbe4-d85d1cbf0c9d-000000@email.amazonses.com>
 <20130527064834.GA2781@laptop>
 <0000013eec0006ee-0f8caf7b-cc94-4f54-ae38-0ca6623b7841-000000@email.amazonses.com>
 <20130529075845.GA24506@gmail.com>
 <51A65CC0.3050800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A65CC0.3050800@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:

> Hi
> 
> I'm unhappy you guys uses offensive word so much. Please cool down all 
> you guys. :-/ In fact, _BOTH_ the behavior before and after Cristoph's 
> patch doesn't have cleaner semantics.

Erm, this feature _regressed_ after the patch. All other concerns are 
secondary. What's so difficult to understand about that?

> And PeterZ proposed make new cleaner one rather than revert. No need to 
> hassle.

Sorry, that's not how we deal with regressions upstream...

I've been pretty polite in fact, compared to say Linus - someone should 
put a politically correct summary of:

   https://lkml.org/lkml/2013/2/22/456
   https://lkml.org/lkml/2013/3/26/1113

into Documentation/, people keep forgetting about it.

I'm sorry if being direct and to the point offends you [no, not really], 
this discussion got _way_ off the real track it should be on: that this is 
a _regression_.

Thanks,

	Ingo

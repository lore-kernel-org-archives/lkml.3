Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab3EaJ1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:27:14 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59283 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab3EaJ1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:27:10 -0400
Date: Fri, 31 May 2013 11:27:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Peter Zijlstra <peterz@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland Dreier <roland@kernel.org>, infinipath@qlogic.com,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, linux-rdma@vger.kernel.org,
        Or Gerlitz <or.gerlitz@gmail.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [RFC][PATCH] mm: Fix RLIMIT_MEMLOCK
Message-ID: <20130531092704.GA30394@gmail.com>
References: <20130523163901.GG23650@twins.programming.kicks-ass.net>
 <0000013ed28b638a-066d7dc7-b590-49f8-9423-badb9537b8b6-000000@email.amazonses.com>
 <20130524140114.GK23650@twins.programming.kicks-ass.net>
 <0000013ed732b615-748f574f-ccb8-4de7-bbe4-d85d1cbf0c9d-000000@email.amazonses.com>
 <20130527064834.GA2781@laptop>
 <0000013eec0006ee-0f8caf7b-cc94-4f54-ae38-0ca6623b7841-000000@email.amazonses.com>
 <20130529075845.GA24506@gmail.com>
 <51A65CC0.3050800@gmail.com>
 <20130530063205.GA5310@gmail.com>
 <CAHGf_=qkJWEhwKRY4gu0wL4OLU1PhOW3=n6JNmAocSK-T0PhmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHGf_=qkJWEhwKRY4gu0wL4OLU1PhOW3=n6JNmAocSK-T0PhmA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:

> >> I'm unhappy you guys uses offensive word so much. Please cool down all
> >> you guys. :-/ In fact, _BOTH_ the behavior before and after Cristoph's
> >> patch doesn't have cleaner semantics.
> >
> > Erm, this feature _regressed_ after the patch. All other concerns are
> > secondary. What's so difficult to understand about that?
> 
> Because it is not new commit at all. Christoph's patch was introduced
> 10 releases before.

That's indeed sad - resource limits are not typically tested by apps. The 
lack of Cc:s to people affected also helped hide the effects of the 
change.

> $ git describe bc3e53f682
> v3.1-7235-gbc3e53f
> 
> If we just revert it, we may get another and opposite regression report. 
> I'm worried about it. Moreover, I don't think discussion better fix is 
> too difficult for us.

Sure, I agree that a fix is generally better.

Thanks,

	Ingo

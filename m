Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272Ab3E3Umo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:42:44 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:44393 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012Ab3E3Umg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:42:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130530063205.GA5310@gmail.com>
References: <20130523152458.GD23650@twins.programming.kicks-ass.net>
 <0000013ed2297ba8-467d474a-7068-45b3-9fa3-82641e6aa363-000000@email.amazonses.com>
 <20130523163901.GG23650@twins.programming.kicks-ass.net> <0000013ed28b638a-066d7dc7-b590-49f8-9423-badb9537b8b6-000000@email.amazonses.com>
 <20130524140114.GK23650@twins.programming.kicks-ass.net> <0000013ed732b615-748f574f-ccb8-4de7-bbe4-d85d1cbf0c9d-000000@email.amazonses.com>
 <20130527064834.GA2781@laptop> <0000013eec0006ee-0f8caf7b-cc94-4f54-ae38-0ca6623b7841-000000@email.amazonses.com>
 <20130529075845.GA24506@gmail.com> <51A65CC0.3050800@gmail.com> <20130530063205.GA5310@gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Thu, 30 May 2013 16:42:15 -0400
Message-ID: <CAHGf_=qkJWEhwKRY4gu0wL4OLU1PhOW3=n6JNmAocSK-T0PhmA@mail.gmail.com>
Subject: Re: [RFC][PATCH] mm: Fix RLIMIT_MEMLOCK
To: Ingo Molnar <mingo@kernel.org>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I'm unhappy you guys uses offensive word so much. Please cool down all
>> you guys. :-/ In fact, _BOTH_ the behavior before and after Cristoph's
>> patch doesn't have cleaner semantics.
>
> Erm, this feature _regressed_ after the patch. All other concerns are
> secondary. What's so difficult to understand about that?

Because it is not new commit at all. Christoph's patch was introduced
10 releases before.

$ git describe bc3e53f682
v3.1-7235-gbc3e53f

If we just revert it, we may get another and opposite regression
report. I'm worried
about it. Moreover, I don't think discussion better fix is too difficult for us.
